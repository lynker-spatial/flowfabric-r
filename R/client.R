#' List all available datasets
#' @importFrom flowfabricr flowfabric_post
#'
#' @return A data.frame of datasets
##' @examples
##' \dontrun{
##' # List all datasets (uses default token)
##' datasets <- flowfabric_list_datasets()
##' # List datasets with explicit token
##' token <- flowfabric_get_token()
##' datasets <- flowfabric_list_datasets(token)
##' }
#' @export
flowfabric_list_datasets <- function(token = NULL) {
  resp <- flowfabric_get("/v1/datasets", token = token)
  json <- httr2::resp_body_json(resp)

  # Only keep named lists (valid dataset objects)
  json <- Filter(function(x) !is.null(x) && is.list(x) && !is.null(names(x)) && length(x) > 0, json)
  if (length(json) == 0) {
    return(data.frame())
  }

  all_fields <- unique(unlist(lapply(json, names)))
  json_flat <- lapply(json, function(x) {
    x[sapply(x, is.list)] <- lapply(x[sapply(x, is.list)], jsonlite::toJSON, auto_unbox = TRUE)
    for (f in setdiff(all_fields, names(x))) x[[f]] <- NA
    # Coerce any zero-length fields to NA
    for (f in all_fields) {
      if (length(x[[f]]) == 0) x[[f]] <- NA
    }
    x[all_fields]
  })
  # Strictly filter: only non-empty, named lists with at least one non-NA value
  json_flat <- Filter(function(x) {
    is.list(x) && !is.null(names(x)) && length(x) > 0 && any(!sapply(x, function(v) is.null(v) || (is.atomic(v) && all(is.na(v)))))
  }, json_flat)
  if (length(json_flat) == 0) {
    return(data.frame(matrix(ncol = length(all_fields), nrow = 0, dimnames = list(NULL, all_fields))))
  }
  # Ensure all entries have all fields
  json_flat <- lapply(json_flat, function(x) {
    for (f in setdiff(all_fields, names(x))) x[[f]] <- NA
    x[all_fields]
  })
  as.data.frame(do.call(rbind, lapply(json_flat, as.data.frame, stringsAsFactors = FALSE)))
}

##' Query streamflow
#' @param dataset_id Dataset identifier
#' @param feature_ids Optional. Character vector of feature IDs
#' @param start_time Optional. Start time of desired data
#' @param end_time Optional. End time of desired data
#' @param issue_time Optional. Issue time for query parameters
#' @param token Optional. Bearer token. If NULL, will use get_bearer_token().
#' @param params Optional. List of query parameters (see API docs)
#' @param ... Optional. Additional parameters (passed as named list)
#' @param verbose Optional. Use TRUE for debugging purposes
#' @return Returns a data frame or parsed JSON
##' @examples
##' \dontrun{
##' result <- flowfabric_streamflow_query(
##'   "nws_owp_nwm_analysis",
##'   params = params
##' )
##'
##' result <- flowfabric_streamflow_query(
##'   "nws_owp_nwm_short_range",
##'   feature_ids = c("101", "1001"),
##'   issue_time = "latest"
##' )
##'
##' result <- flowfabric_streamflow_query(
##'   "nws_owp_nwm_reanalysis_3_0",
##'   feature_ids = c("101", "1001"),
##'   start_time = "2018-01-01",
##'   end_time = "2018-01-31"
##' )
##' }
#' @export
flowfabric_streamflow_query <- function(dataset_id, feature_ids = NULL, start_time = NULL, end_time = NULL, issue_time = NULL, token = NULL, ..., params = NULL, verbose = FALSE) {
  # If params is provided, use it directly (backward compatibility)
  if (!is.null(params)) {
    query_params <- params
  } else {
    query_params <- list()
    dots <- list(...)
    # Add explicit arguments if provided
    if (!is.null(feature_ids)) {
      query_params$feature_ids <- as.character(feature_ids)
      query_params$scope <- "features"
    }
    # Normalize start_time and end_time to full ISO8601 UTC if only date is provided
    normalize_time <- function(x, is_start = TRUE) {
      if (is.null(x)) return(NULL)
      # If already has T and Z, return as is
      if (grepl("T", x) && grepl("Z$", x)) return(x)
      # If only date, append appropriate time
      if (grepl("^\\d{4}-\\d{2}-\\d{2}$", x)) {
        if (is_start) {
          return(paste0(x, "T00:00:00Z"))
        } else {
          return(paste0(x, "T23:59:59Z"))
        }
      }
      # Otherwise, return as is
      return(x)
    }
    if (!is.null(start_time)) query_params$start_time <- normalize_time(start_time, is_start = TRUE)
    if (!is.null(end_time)) query_params$end_time <- normalize_time(end_time, is_start = FALSE)
    if (!is.null(issue_time)) query_params$issue_time <- issue_time
    # Add any ... arguments
    for (nm in names(dots)) {
      query_params[[nm]] <- dots[[nm]]
    }
    # Auto-fill missing key params using catalog heuristics
    if (!exists("auto_streamflow_params", mode = "function")) {
      source("R/catalog_utils.R")
    }
    auto_params <- auto_streamflow_params(dataset_id)
    # Fill in any missing required params from auto_params
    for (nm in names(auto_params)) {
      if (is.null(query_params[[nm]])) {
        query_params[[nm]] <- auto_params[[nm]]
      }
    }
    # If nothing provided, use auto-populated params entirely
    if (length(query_params) == 0) {
      query_params <- auto_params
      message("[flowfabric_streamflow_query] Auto-populated params from catalog.")
    }
  }
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_streamflow_query] Using token from get_bearer_token()")
  }
  if (verbose) message("[flowfabric_streamflow_query] Token: ", substr(token, 1, 20), "...")
  # Pre-fetch dataset metadata to detect Zarr stores (avoid presigning Zarr sources)
  is_zarr <- FALSE
  meta_json <- NULL
  try({
    meta_endpoint <- paste0("/v1/datasets/", dataset_id)
    meta_resp <- flowfabric_get(meta_endpoint, token = token)
    meta_json <- httr2::resp_body_json(meta_resp)
    if (!is.null(meta_json$storage_type) && tolower(meta_json$storage_type) == "zarr") is_zarr <- TRUE
    if (!is.null(meta_json$config) && !is.null(meta_json$config$format) && tolower(meta_json$config$format) == "zarr") is_zarr <- TRUE
    if (!is.null(meta_json$storage) && !is.null(meta_json$storage$type) && tolower(meta_json$storage$type) == "zarr") is_zarr <- TRUE
  }, silent = TRUE)

  # If dataset is Zarr, skip the presign/estimate step to avoid presigning directory stores
  est_json <- NULL
  if (!is_zarr) {
    # Request an estimate; the server may return an export_url we can read directly
    est_endpoint <- paste0("/v1/datasets/", dataset_id, "/streamflow?estimate=true")
    est_resp <- flowfabric_post(est_endpoint, body = query_params, token = token, verbose = verbose)
    # Parse estimate response (httr2 response)
    est_json <- httr2::resp_body_json(est_resp)
  }
  export_url <- NULL
  if (!is.null(est_json) && !is.null(est_json$export_url)) {
    export_url <- est_json$export_url
  }

  # If an export_url was provided, prefer reading it directly with Arrow
  if (!is.null(export_url) && nzchar(export_url)) {
    # For Zarr-backed datasets, avoid attempting to directly read a source parquet
    is_zarr <- FALSE
    try({
      meta_endpoint <- paste0("/v1/datasets/", dataset_id)
      meta_resp <- flowfabric_get(meta_endpoint, token = token)
      meta_json <- httr2::resp_body_json(meta_resp)
      if (!is.null(meta_json$storage_type) && tolower(meta_json$storage_type) == "zarr") is_zarr <- TRUE
      if (!is.null(meta_json$config) && !is.null(meta_json$config$format) && tolower(meta_json$config$format) == "zarr") is_zarr <- TRUE
      if (!is.null(meta_json$storage) && !is.null(meta_json$storage$type) && tolower(meta_json$storage$type) == "zarr") is_zarr <- TRUE
    }, silent = TRUE)

    # If zarr, only honor export_url if it looks like a materialized export (exports/ in path)
    allow_direct <- TRUE
    if (is_zarr) {
      allow_direct <- grepl("/exports/", export_url)
      if (verbose) message("[flowfabric_streamflow_query] Dataset appears to be Zarr (is_zarr=", is_zarr, "); allow_direct=",
                            allow_direct)
    }

    if (allow_direct) {
      if (verbose) message("[flowfabric_streamflow_query] Server recommended export; reading export_url: ", substr(export_url, 1, 120))
      # Try direct Arrow read first (depends on Arrow build supporting HTTP)
      tryCatch({
        tbl <- arrow::read_parquet(export_url)
        return(tbl)
      }, error = function(e) {
        message("Direct arrow read failed: ", e$message, " - falling back to download")
        tf <- tempfile(fileext = ".parquet")
        curl::curl_download(export_url, tf)
        return(arrow::read_parquet(tf))
      })
    } else {
      if (verbose) message("[flowfabric_streamflow_query] Ignoring export_url for Zarr dataset; proceeding with streaming query")
    }
  }

  # Otherwise proceed with the normal sync/streaming request
  endpoint <- paste0("/v1/datasets/", dataset_id, "/streamflow")
  resp <- flowfabric_post(endpoint, body = query_params, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_streamflow_query] Request body: ", paste(utils::capture.output(utils::str(query_params)), collapse = " "))
  if (verbose) message("[flowfabric_streamflow_query] Response status: ", httr2::resp_status(resp))
  # Check the Content-Type of the response
  content_type <- httr2::resp_content_type(resp)
  if (verbose) message("[flowfabric_streamflow_query] Content-Type: ", content_type)

  # Parse response based on Content-Type
  if (grepl("application/vnd\\.apache\\.arrow\\.stream", content_type, ignore.case = TRUE)) {
    if (verbose) message("[flowfabric_streamflow_query] Parsing response as Arrow IPC stream.")
    raw_body <- httr2::resp_body_raw(resp)
    preview_len <- min(64, length(raw_body))
    text_preview <- tryCatch(rawToChar(raw_body[1:preview_len]), error = function(e) "<binary>")
    if (verbose) message("[flowfabric_streamflow_query] Raw body (text preview): ", text_preview)
    # If the body looks like JSON, handle as base64-encoded Arrow
    if (startsWith(text_preview, "{")) {
      json <- jsonlite::fromJSON(rawToChar(raw_body))
      if (!is.null(json$data)) {
        if (verbose) message("[flowfabric_streamflow_query] Detected base64-encoded Arrow in JSON 'data' field.")
        arrow_bin <- base64enc::base64decode(json$data)
        tbl <- arrow::read_ipc_stream(arrow_bin)
        if ("time" %in% names(tbl)) {
          tbl$time <- as.POSIXct(tbl$time, tz = "UTC")
        }
        return(tbl)
      } else {
        stop("JSON response does not contain 'data' field for Arrow stream.")
      }
    } else {
      # Try to parse as Arrow binary
      tryCatch({
        tbl <- arrow::read_ipc_stream(raw_body)
        if ("time" %in% names(tbl)) {
          tbl$time <- as.POSIXct(tbl$time, tz = "UTC")
        }
        return(tbl)
      }, error = function(e) {
        stop("Failed to parse Arrow IPC stream: ", e$message)
      })
    }
  } else if (grepl("application/json", content_type, ignore.case = TRUE)) {
    if (verbose) message("[flowfabric_streamflow_query] Parsing response as JSON.")
    tryCatch({
      if (verbose) message("[flowfabric_streamflow_query] Response body: ", paste(utils::capture.output(utils::str(httr2::resp_body_json(resp))), collapse = " "))
      json_data <- httr2::resp_body_json(resp)
      return(json_data)
    }, error = function(e) {
      stop("Failed to parse JSON response: ", e$message)
    })
  } else {
    stop("Unsupported content type: ", content_type)
  }
}

##' Query REM ratings (stage-discharge relationships)
#' @param feature_ids Character vector of feature IDs (required)
#' @param type Ratings type: 'rem' (default) or 'ahps'
#' @param format Output format: 'arrow' (default), 'json', or 'parquet'
#' @param token Optional. Bearer token. If NULL, will use flowfabric_get_token().
#' @param ... Additional parameters (passed as named list)
#' @param verbose Use TRUE for debugging purposes
#' @return Parsed response (Arrow Table, data.frame, or list depending on format)
#' @examples
#' \dontrun{
#' ratings <- flowfabric_ratings_query(feature_ids = c("101", "1001"), type = "rem")
#' }
#' @export
flowfabric_ratings_query <- function(feature_ids, type = "rem", format = "arrow", token = NULL, ..., verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_ratings_query] Using token from get_bearer_token()")
  }
  params <- list(
    feature_ids = feature_ids,
    type = type,
    format = format
  )
  # Add any additional params
  dots <- list(...)
  if (length(dots) > 0) {
    params <- c(params, dots)
  }
  endpoint <- "/v1/ratings"
  resp <- flowfabric_post(endpoint, body = params, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_ratings_query] Request body: ", paste(utils::capture.output(utils::str(params)), collapse = " "))
  if (verbose) message("[flowfabric_ratings_query] Response status: ", httr2::resp_status(resp))
  if (tolower(format) == "arrow") {
    if (verbose) message("[flowfabric_ratings_query] Parsing response as Arrow IPC stream.")
    return(arrow::read_ipc_stream(httr2::resp_body_raw(resp)))
  } else {
    if (verbose) message("[flowfabric_ratings_query] Parsing response as JSON.")
    return(httr2::resp_body_json(resp))
  }
}

##' Estimate size of ratings query
#' @param feature_ids Character vector of feature IDs (required)
#' @param type Ratings type: 'rem' (default) or 'ahps'
#' @param format Output format: 'json', or 'parquet'
#' @param token Optional. Bearer token. If NULL, will use flowfabric_get_token().
#' @param ... Additional parameters (passed as named list)
#' @param verbose Use TRUE for debugging purposes
#' @return Estimated rows, bytes, and would_exceed_limits (boolean)
##' @examples
##' \dontrun{
##' ratings <- flowfabric_ratings_estimate(feature_ids = c("101", "1001"), type = "rem")
##' }
##' @export
flowfabric_ratings_estimate <- function(feature_ids, type = "rem", format = "json", token = NULL, ..., verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_ratings_estimate] Using token from get_bearer_token()")
  }
  params <- list(
    feature_ids = feature_ids,
    type = type,
    format = format
  )
  # Add any additional params
  dots <- list(...)
  if (length(dots) > 0) {
    params <- c(params, dots)
  }
  endpoint <- "/v1/ratings?estimate=TRUE"
  resp <- flowfabric_post(endpoint, body = params, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_ratings_estimate] Request body: ", paste(capture.output(str(params)), collapse = " "))
  if (verbose) message("[flowfabric_ratings_estimate] Response status: ", httr2::resp_status(resp))
  if (verbose) message("[flowfabric_ratings_estimate] Parsing response as JSON.")
  return(httr2::resp_body_json(resp))
}

##' Query stage data (Arrow IPC)
#' @param dataset_id Dataset identifier
#' @param params List of query parameters (see API docs)
#' @param token Optional. Bearer token. If NULL, will use flowfabric_get_token().
#' @param ... Optional. Additional parameters (passed as named list)
#' @param verbose Optional. Use TRUE for debugging purposes
#' @return An Arrow Table
##' @examples
##' \dontrun{
##' tbl <- flowfabric_stage_query(
##'   dataset_id = "usgs-nwis-stage",
##'   params = list(feature_ids = c("101"))
##' )
##' df <- as.data.frame(tbl)
##' }
#' @export
flowfabric_stage_query <- function(dataset_id, params = NULL, token = NULL, ..., verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_stage_query] Using token from get_bearer_token()")
  }
  if (is.null(params)) {
    params <- list(...)
    # Optionally, add auto-population logic here if desired
  }
  # Stage endpoint expects a StageRequest body containing dataset_id and query params
  body <- params
  body$dataset_id <- dataset_id
  endpoint <- "/v1/stage"
  resp <- flowfabric_post(endpoint, body = body, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_stage_query] Request body: ", paste(utils::capture.output(utils::str(params)), collapse = " "))
  if (verbose) message("[flowfabric_stage_query] Response status: ", httr2::resp_status(resp))
  if (verbose) message("[flowfabric_stage_query] Parsing response as Arrow IPC stream.")
  arrow::read_ipc_stream(httr2::resp_body_raw(resp))
}

#' Get dataset details from catalog
#'
#' Wrapper for GET /v1/datasets/{dataset_id} returning parsed JSON dataset object.
#' @param dataset_id Dataset identifier
#' @param token Optional Bearer token. If NULL, will use `get_bearer_token()`
#' @param verbose Logical; print debug messages
#' @examples
#' \dontrun{
#' dataset <- flowfabric_get_dataset("nws_owp_nwm_analysis")
#' }
#' @export
flowfabric_get_dataset <- function(dataset_id, token = NULL, verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_get_dataset] Using token from get_bearer_token()")
  }
  endpoint <- paste0("/v1/datasets/", dataset_id)
  resp <- flowfabric_get(endpoint, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_get_dataset] Parsing response as JSON.")
  httr2::resp_body_json(resp)
}


#' Get latest run for a dataset
#'
#' Wrapper for GET /v1/datasets/{dataset_id}/runs/latest returning parsed JSON.
#' @param dataset_id Dataset identifier
#' @param token Optional Bearer token. If NULL, will use `get_bearer_token()`
#' @param verbose Logical; print debug messages
#' @examples
#' \dontrun{
#' latest <- flowfabric_get_latest_run("nws_owp_nwm_analysis")
#' }
#' @export
flowfabric_get_latest_run <- function(dataset_id, token = NULL, verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_get_latest_run] Using token from get_bearer_token()")
  }
  endpoint <- paste0("/v1/datasets/", dataset_id, "/runs/latest")
  resp <- flowfabric_get(endpoint, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_get_latest_run] Parsing response as JSON.")
  httr2::resp_body_json(resp)
}


#' Get a specific run by issue_time
#'
#' Wrapper for GET /v1/datasets/{dataset_id}/runs/{issue_time} returning parsed JSON.
#' @param dataset_id Dataset identifier
#' @param issue_time Issue time string (e.g., "2026012316")
#' @param token Optional Bearer token. If NULL, will use `get_bearer_token()`
#' @param verbose Logical; print debug messages
#' @examples
#' \dontrun{
#' recent_run <- flowfabric_get_run("nws_owp_nwm_analysis", issue_time = "2026010514")
#' }
#' @export
flowfabric_get_run <- function(dataset_id, issue_time, token = NULL, verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_get_run] Using token from get_bearer_token()")
  }
  endpoint <- paste0("/v1/datasets/", dataset_id, "/runs/", issue_time)
  resp <- flowfabric_get(endpoint, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_get_run] Parsing response as JSON.")
  httr2::resp_body_json(resp)
}


#' Estimate streamflow result size and get export_url when available
#'
#' Wrapper for the /v1/datasets/{dataset_id}/streamflow endpoint (estimate mode).
#' Calls `POST /v1/datasets/{dataset_id}/streamflow?estimate=true` and returns the parsed JSON estimate object (list).
#' @param dataset_id Dataset identifier
#' @param params List of query parameters (see API docs)
#' @param token Optional Bearer token. If NULL, will use `get_bearer_token()`
#' @param verbose Logical; print debug messages
#' @examples
#' \dontrun{
#' result <- flowfabric_streamflow_estimate(dataset_id, params = list(
#'   query_mode = "run",
#'   feature_ids = c("101"),
#'   issue_time = "latest",
#'   scope = "features",
#'   lead_start = 0,
#'   lead_end = 0,
#'   format = "arrow"
#'   )
#' )
#' }
#' @export
flowfabric_streamflow_estimate <- function(dataset_id, params = list(), token = NULL, verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_streamflow_estimate] Using token from get_bearer_token()")
  }
  endpoint <- paste0("/v1/datasets/", dataset_id, "/streamflow?estimate=true")
  resp <- flowfabric_post(endpoint, body = params, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_streamflow_estimate] Parsing response as JSON.")
  return(httr2::resp_body_json(resp))
}


#' Query inundation ids
#'
#' Wrapper for `POST /v1/inundation-ids` returning parsed JSON.
#' @param params List of query parameters (see API docs)
#' @param token Optional Bearer token. If NULL, will use `get_bearer_token()`
#' @param verbose Logical; print debug messages
#' @examples
#' \dontrun{
#' polygons <- flowfabric_inundation_ids(params=auto_streamflow_params("nws_owp_nwm_analysis))
#' }
#' @export
flowfabric_inundation_ids <- function(params = list(), token = NULL, verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_inundation_ids] Using token from get_bearer_token()")
  }
  endpoint <- "/v1/inundation-ids"
  resp <- flowfabric_post(endpoint, body = params, token = token, verbose = verbose)
  if (verbose) message("[flowfabric_inundation_ids] Parsing response as JSON.")
  httr2::resp_body_json(resp)
}


#' Health check
#'
#' Wrapper for `GET /healthz` returning parsed JSON (or status object).
#' @param token Optional Bearer token. If NULL, will use `get_bearer_token()`
#' @param verbose Logical; print debug messages
#' @examples
#' \dontrun{
#'   health <- flowfabric_healthz()
#' }
#' @export
flowfabric_healthz <- function(token = NULL, verbose = FALSE) {
  if (is.null(token)) {
    token <- get_bearer_token()
    if (verbose) message("[flowfabric_healthz] Using token from get_bearer_token()")
  } 
  resp <- flowfabric_get("/healthz", token = token, verbose = verbose)
  if (verbose) message("[flowfabric_healthz] Parsing response as JSON.")
  httr2::resp_body_json(resp)
}

# Utility function for token retrieval
#' Retrieve Bearer Token
#'
#' This function retrieves a Bearer token using `hfutils::lynker_spatial_auth`.
#' @param force_refresh Will always refresh the token if TRUE
#' @return A character string containing the Bearer token.
##' @examples
##' \dontrun{
##' token <- get_bearer_token()
##' }
#' @export
get_bearer_token <- function(force_refresh = FALSE) {
  # Always use the unified token getter
  token <- flowfabric_get_token(force_refresh = force_refresh)
  if (is.character(token) && nzchar(token)) {
    return(token)
  } else {
    stop("No valid token found. If running in a non-interactive environment, please cache a token or set it explicitly.")
  }
}
