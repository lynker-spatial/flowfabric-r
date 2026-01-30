#' Perform a GET request to the FlowFabric API
#'
#' @param endpoint API endpoint (e.g., "/v1/datasets")
#' @param token Optional. Bearer token. If NULL, will use flowfabric_get_token().
#' @param ... Additional httr2::request() options
#' @examples
#' \dontrun{
#' # GET request to a FlowFabric endpoint
#' resp <- flowfabric_get("/datasets", token = flowfabric_get_token())
#' }
#' @return httr2 response object
#' @export
flowfabric_get <- function(endpoint, token = NULL, ...) {
  if (missing(endpoint) || is.null(endpoint) || !nzchar(endpoint)) {
    stop("[flowfabric_get] 'endpoint' must be a non-empty string.", call. = FALSE)
  }
  if (is.null(token)) token <- flowfabric_get_token()
  base_url <- getOption("flowfabric.api_url", "https://flowfabric-api.lynker-spatial.com")
  url <- paste0(base_url, endpoint)
  req <- httr2::request(url) |>
    httr2::req_headers(Authorization = paste("Bearer", token))
  req <- httr2::req_options(req, ...)
  httr2::req_perform(req)
}

#' Perform a POST request to the FlowFabric API
#'
#' @param endpoint API endpoint (e.g., "/v1/datasets/nwm-forecast/streamflow")
#' @param body List. JSON body for the request.
#' @param token Optional. Bearer token. If NULL, will use flowfabric_get_token().
#' @param ... Additional httr2::request() options
#' @param verbose Use TRUE for debugging purposes
#' @examples
#' \dontrun{
#' # POST request to a FlowFabric endpoint
#' resp <- flowfabric_post("/datasets", body = list(name = "test"), token = flowfabric_get_token())
#' }
#' @return httr2 response object
#' @export
flowfabric_post <- function(endpoint, body, token = NULL, ..., verbose = FALSE) {
  if (missing(endpoint) || is.null(endpoint) || !nzchar(endpoint)) {
    stop("[flowfabric_post] 'endpoint' must be a non-empty string.", call. = FALSE)
  }
  if (is.null(token)) token <- flowfabric_get_token()
  base_url <- getOption("flowfabric.api_url", "https://flowfabric-api.lynker-spatial.com")
    url <- paste0(base_url, endpoint)
    # Remove any leading 'Bearer ' from token before prepending
    clean_token <- sub('^Bearer ', '', token)
    auth_header <- paste("Bearer", clean_token)
    if (verbose) message("[flowfabric_post] URL: ", url)
    if (verbose) message("[flowfabric_post] Authorization: ", auth_header)
    if (verbose) message("[flowfabric_post] Body: ", paste(capture.output(str(body)), collapse = " "))
    # Ensure feature_ids is always a list for JSON
    if (!is.null(body$feature_ids)) {
      body$feature_ids <- as.list(body$feature_ids)
    }
    req <- httr2::request(url) |>
      httr2::req_headers(Authorization = auth_header) |>
      httr2::req_body_json(body)
  req <- httr2::req_options(req, ...)
  httr2::req_perform(req)
}
