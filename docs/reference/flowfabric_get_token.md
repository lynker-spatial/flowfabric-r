# Get a JWT Bearer Token for FlowFabric API

Uses improved authentication from hfutils to obtain a valid JWT token
for API requests.

## Usage

``` r
flowfabric_get_token(force_refresh = FALSE)
```

## Arguments

- force_refresh:

  Will always refresh the token if TRUE

## Value

A character string containing the JWT Bearer token

## Examples

``` r
if (FALSE) { # \dontrun{
token <- flowfabric_get_token()
} # }
```
