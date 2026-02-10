# Estimate streamflow result size and get export_url when available

Wrapper for the /v1/datasets/{dataset_id}/streamflow endpoint (estimate
mode). Calls \`POST /v1/datasets/{dataset_id}/streamflow?estimate=true\`
and returns the parsed JSON estimate object (list).

## Usage

``` r
flowfabric_streamflow_estimate(
  dataset_id,
  params = NULL,
  token = NULL,
  verbose = FALSE
)
```

## Arguments

- dataset_id:

  Dataset identifier

- params:

  List of query parameters (see API docs)

- token:

  Optional Bearer token. If NULL, will use \`get_bearer_token()\`

- verbose:

  Logical; print debug messages

## Examples

``` r
if (FALSE) { # \dontrun{
result <- flowfabric_streamflow_estimate(dataset_id, params = list(
  query_mode = "run",
  feature_ids = c("101"),
  issue_time = "latest",
  scope = "features",
  lead_start = 0,
  lead_end = 0,
  format = "arrow"
  )
)
} # }
```
