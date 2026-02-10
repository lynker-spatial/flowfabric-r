# Manage global FlowFabric API token

Set or get the global token used for authentication. If not set, will
attempt to obtain one using flowfabric_get_token().

## Usage

``` r
flowfabric_token(refresh = FALSE)
```

## Arguments

- refresh:

  Force refreshes the token if true
