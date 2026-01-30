##' Get a JWT Bearer Token for FlowFabric API
#'
#' Uses improved authentication from hfutils to obtain a valid JWT token for API requests.
#' @param force_refresh Will always refresh the token if TRUE
#' @return A character string containing the JWT Bearer token
#' @examples
#' \dontrun{
#' token <- flowfabric_get_token()
#' }
#' @export
flowfabric_get_token <- function(force_refresh = FALSE) {
  cache_path <- file.path(Sys.getenv("HOME"), ".flowfabric_token")
  read_cache <- function(path) {
    if (!file.exists(path)) return(NULL)
    json <- tryCatch(jsonlite::fromJSON(path), error = function(e) NULL)
    json
  }
  write_cache <- function(path, id_token, expiry) {
    jsonlite::write_json(list(id_token = id_token, expiry = expiry), path, auto_unbox = TRUE)
  }
  get_expiry_from_jwt <- function(token) {
    # JWT: header.payload.signature, payload is 2nd part
    payload <- strsplit(token, "\\.")[[1]][2]
    payload_dec <- rawToChar(jsonlite::base64url_dec(payload))
    exp <- tryCatch(jsonlite::fromJSON(payload_dec)$exp, error = function(e) NULL)
    if (is.null(exp)) return(NULL)
    as.POSIXct(exp, origin = "1970-01-01", tz = "UTC")
  }
  cache <- read_cache(cache_path)
  now <- Sys.time()
  if (!force_refresh && !is.null(cache) && !is.null(cache$id_token) && !is.null(cache$expiry)) {
    expiry <- as.POSIXct(cache$expiry, tz = "UTC")
    if (now < expiry) {
      return(cache$id_token)
    }
  }
  # Authenticate and cache
  token_fun <- tryCatch(get("lynker_spatial_token", asNamespace("hfutils")), error = function(e) NULL)
  refresh_fun <- tryCatch(get("lynker_spatial_refresh", asNamespace("hfutils")), error = function(e) NULL)
  if (is.null(token_fun)) token_fun <- hfutils:::lynker_spatial_token
  if (is.null(refresh_fun)) refresh_fun <- hfutils:::lynker_spatial_refresh
  token <- token_fun()
  if (inherits(token, "httr2_token")) {
    if (force_refresh || ("expires_at" %in% names(token) && now >= as.POSIXct(token$expires_at))) {
      token <- refresh_fun(token)
    }
    id_token <- token$id_token
    expiry <- get_expiry_from_jwt(id_token)
    write_cache(cache_path, id_token, expiry)
    return(id_token)
  } else if (is.character(token)) {
    id_token <- token
    expiry <- get_expiry_from_jwt(id_token)
    write_cache(cache_path, id_token, expiry)
    return(id_token)
  } else {
    stop("Failed to obtain a valid JWT token.")
  }
}

#' Manage global FlowFabric API token
#'
#' Set or get the global token used for authentication. If not set, will attempt to obtain one using flowfabric_get_token().

## Deprecated: use flowfabric_get_token instead
#' @param refresh Force refreshes the token if true
flowfabric_token <- function(refresh = FALSE) {
  .Deprecated("flowfabric_get_token")
  flowfabric_get_token(force_refresh = refresh)
}

flowfabric_refresh_token <- function() {
  flowfabric_get_token(force_refresh = TRUE)
}

#' @export
# flowfabric_token <- local({
#   .token <- NULL
#   function(token = NULL, force_refresh = FALSE) {
#     if (!is.null(token)) {
#       .token <<- token
#       invisible(.token)
#     } else {
#       if (is.null(.token) || force_refresh) {
#         .token <<- flowfabric_get_token(force_refresh = force_refresh)
#       }
#       .token
#     }
#   }
# })
