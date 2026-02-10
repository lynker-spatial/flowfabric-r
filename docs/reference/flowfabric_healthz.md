# Health check

Wrapper for \`GET /healthz\` returning parsed JSON (or status object).

## Usage

``` r
flowfabric_healthz(token = NULL, verbose = FALSE)
```

## Arguments

- token:

  Optional Bearer token. If NULL, will use \`get_bearer_token()\`

- verbose:

  Logical; print debug messages

## Examples

``` r
if (FALSE) { # \dontrun{
  health <- flowfabric_healthz()
} # }
```
