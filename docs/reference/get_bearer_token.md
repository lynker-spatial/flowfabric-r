# Retrieve Bearer Token

This function retrieves a Bearer token using
\`hfutils::lynker_spatial_auth\`.

## Usage

``` r
get_bearer_token(force_refresh = FALSE)
```

## Arguments

- force_refresh:

  Will always refresh the token if TRUE

## Value

A character string containing the Bearer token.

## Examples

``` r
if (FALSE) { # \dontrun{
token <- get_bearer_token()
} # }
```
