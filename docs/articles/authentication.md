# Authentication with flowfabricr

## Authentication

`flowfabricr` uses JWT Bearer authentication. By default, it manages
your token in the background using
[`flowfabric_token()`](../reference/flowfabric_token.md), leveraging the
`hfutils` package for OAuth2 flows. You can also set or override the
token explicitly for any function call.

### Background (global) token

Authenticate once per session:

``` r
is_interactive <- interactive()
if (is_interactive) {
  # This will obtain and cache a token for all API calls
  flowfabric_token()  # triggers login if needed
} else {
  cat('Skipping authentication: not running interactively.\n')
}
```

    ## Skipping authentication: not running interactively.

### Explicit token usage

datasets \<- flowfabric_list_datasets(token = token)

You can pass a token directly to any API function:

``` r
token <- flowfabric_get_token()
datasets <- flowfabric_list_datasets(token = token)
print(datasets)
```

### Getting a Token

You can use the built-in function to obtain a token interactively:

token

``` r
if (is_interactive) {
  token <- flowfabric_get_token()
  print(token)
} else {
  cat('Skipping token retrieval: not running interactively.\n')
}
```

    ## Skipping token retrieval: not running interactively.

Or pass a token directly to any API function:

datasets \<- flowfabric_list_datasets(token = “YOUR_TOKEN”)

``` r
datasets <- flowfabric_list_datasets(token = "YOUR_TOKEN")
```

### Token Refresh

Tokens are automatically refreshed if expired, using the underlying
`hfutils` logic.

See the [hfutils documentation](../reference/index.md) for advanced
authentication options.
