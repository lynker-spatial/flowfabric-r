# Get dataset details from catalog

Wrapper for \`GET /v1/datasets/{dataset_id}\` returning parsed JSON
dataset object.

## Usage

``` r
flowfabric_get_dataset(dataset_id, token = NULL, verbose = FALSE)
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
dataset <- flowfabric_get_dataset("nws_owp_nwm_analysis")
} # }
```
