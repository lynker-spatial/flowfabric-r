# Get latest run for a dataset

Wrapper for \`GET /v1/datasets/{dataset_id}/runs/latest\` returning
parsed JSON.

## Usage

``` r
flowfabric_get_latest_run(dataset_id, token = NULL, verbose = FALSE)
```

## Arguments

- dataset_id:

  Dataset identifier

- token:

  Optional Bearer token. If NULL, will use \`get_bearer_token()\`

- verbose:

  Logical; print debug messages

## Examples

``` r
if (FALSE) { # \dontrun{
latest <- flowfabric_get_latest_run("nws_owp_nwm_analysis")
} # }
```
