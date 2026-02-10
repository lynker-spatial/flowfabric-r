# Perform a GET request to the FlowFabric API

Perform a GET request to the FlowFabric API

## Usage

``` r
flowfabric_get(endpoint, token = NULL, ...)
```

## Arguments

- endpoint:

  API endpoint (e.g., "/v1/datasets")

- token:

  Optional. Bearer token. If NULL, will use flowfabric_get_token().

- ...:

  Additional httr2::request() options

## Value

httr2 response object

## Examples

``` r
if (FALSE) { # \dontrun{
# GET request to a FlowFabric endpoint
resp <- flowfabric_get("/datasets", token = flowfabric_get_token())
} # }
```
