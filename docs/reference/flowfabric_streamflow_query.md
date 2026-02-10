# Query streamflow

Query streamflow

## Usage

``` r
flowfabric_streamflow_query(
  dataset_id,
  feature_ids = NULL,
  start_time = NULL,
  end_time = NULL,
  issue_time = NULL,
  token = NULL,
  ...,
  params = NULL,
  verbose = FALSE
)
```

## Arguments

- dataset_id:

  Dataset identifier

- feature_ids:

  Optional. Character vector of feature IDs

- start_time:

  Optional. Start time of desired data

- end_time:

  Optional. End time of desired data

- issue_time:

  Optional. Issue time for query parameters

- token:

  Optional. Bearer token. If NULL, will use get_bearer_token().

- ...:

  Optional. Additional parameters (passed as named list)

- params:

  Optional. List of query parameters (see API docs)

- verbose:

  Optional. Use TRUE for debugging purposes

## Value

Returns a data frame or parsed JSON

## Examples

``` r
if (FALSE) { # \dontrun{
result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  params = params
)

result <- flowfabric_streamflow_query(
  "nws_owp_nwm_short_range",
  feature_ids = c("101", "1001"),
  issue_time = "latest"
)

result <- flowfabric_streamflow_query(
  "nws_owp_nwm_reanalysis_3_0",
  feature_ids = c("101", "1001"),
  start_time = "2018-01-01",
  end_time = "2018-01-31"
)
} # }
```
