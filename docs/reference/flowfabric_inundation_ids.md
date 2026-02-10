# Query inundation ids

Wrapper for \`POST /v1/inundation-ids\` returning parsed JSON.

## Usage

``` r
flowfabric_inundation_ids(params = list(), token = NULL, verbose = FALSE)
```

## Arguments

- params:

  List of query parameters (see API docs)

- token:

  Optional Bearer token. If NULL, will use \`get_bearer_token()\`

- verbose:

  Logical; print debug messages

## Examples

``` r
if (FALSE) { # \dontrun{
polygons <- flowfabric_inundation_ids(params=auto_streamflow_params("nws_owp_nwm_analysis"))
} # }
```
