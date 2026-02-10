# List all available datasets

List all available datasets

## Usage

``` r
flowfabric_list_datasets(token = NULL)
```

## Arguments

- token:

  Optional. Bearer token. If NULL, will use get_bearer_token().

## Value

A data.frame of datasets

## Examples

``` r
if (FALSE) { # \dontrun{
# List all datasets (uses default token)
datasets <- flowfabric_list_datasets()
# List datasets with explicit token
token <- flowfabric_get_token()
datasets <- flowfabric_list_datasets(token)
} # }
```
