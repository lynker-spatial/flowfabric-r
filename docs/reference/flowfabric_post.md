# Perform a POST request to the FlowFabric API

Perform a POST request to the FlowFabric API

## Usage

``` r
flowfabric_post(endpoint, body, token = NULL, ..., verbose = FALSE)
```

## Arguments

- endpoint:

  API endpoint (e.g., "/v1/datasets/nwm-forecast/streamflow")

- body:

  List. JSON body for the request.

- token:

  Optional. Bearer token. If NULL, will use flowfabric_get_token().

- ...:

  Additional httr2::request() options

- verbose:

  Use TRUE for debugging purposes

## Value

httr2 response object

## Examples

``` r
if (FALSE) { # \dontrun{
# POST request to a FlowFabric endpoint
resp <- flowfabric_post("/datasets", body = list(name = "test"), token = flowfabric_get_token())
} # }
```
