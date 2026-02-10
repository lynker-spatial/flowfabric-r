# Advanced Usage of flowfabricr

\#’ @setup

## Advanced Usage

This vignette covers advanced features of `flowfabricr`, including
custom HTTP requests, error handling, and working with Arrow IPC data.

### Custom HTTP Requests

You can use the low-level HTTP helpers for custom endpoints:

``` r
if (is_interactive) {
  resp <- flowfabric_get("/healthz")
  print(httr2::resp_body_json(resp))
} else {
  cat('Skipping HTTP request: not running interactively.\n')
}
```

    ## Skipping HTTP request: not running interactively.

### Error Handling

All API errors return a structured JSON error. Use `tryCatch` to handle
errors gracefully:

``` r
if (is_interactive) {
  tryCatch({
    flowfabric_streamflow_query("bad-dataset", list())
  }, error = function(e) {
    message("API error: ", e$message)
  })
} else {
  cat('Skipping error handling example: not running interactively.\n')
}
```

    ## Skipping error handling example: not running interactively.

### Arrow IPC Data

All data queries return Arrow tables. Convert to data.frame as needed:

``` r
if (is_interactive) {
  tbl <- flowfabric_streamflow_query("nwm-forecast", list(issue_time = "latest", scope = "features", feature_ids = c("101")))
  df <- as.data.frame(tbl)
  head(df)
} else {
  cat('Skipping Arrow IPC example: not running interactively.\n')
}
```

    ## Skipping Arrow IPC example: not running interactively.
