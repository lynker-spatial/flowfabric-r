# Getting Started with flowfabricr

## Overview

`flowfabricr` provides a high-performance R interface to the FlowFabric
REST API, including JWT authentication. This vignette demonstrates basic
usage for expert R users. All code examples are wrapped in `\dontrun{}`
to avoid accidental execution in non-interactive environments.

## Authentication

Authentication uses a Bearer token. By default, `flowfabricr` manages
your token in the background using
[`flowfabric_token()`](../reference/flowfabric_token.md). You can also
set or override the token explicitly for any function call.

### Background (global) token

Authenticate once per session:

``` r
if (is_interactive) {
  # This will obtain and cache a token for all API calls
  flowfabric_token()  # triggers login if needed
} else {
  cat('Skipping authentication: not running interactively.\n')
}
```

    ## Skipping authentication: not running interactively.

### Explicit token usage

You can pass a token directly to any function:

datasets \<- flowfabric_list_datasets(token = token)

``` r
if (is_interactive) {
  token <- flowfabric_get_token()
  datasets <- flowfabric_list_datasets(token = token)
  print(datasets)
} else {
  cat('Skipping dataset listing: not running interactively.\n')
}
```

    ## Skipping dataset listing: not running interactively.

See the [Authentication vignette](authentication.md) for more details.

``` r
\dontrun{
datasets <- flowfabric_list_datasets()
datasets
}
```

## List Datasets

``` r
\dontrun{
datasets <- flowfabric_list_datasets()
datasets
}
```

## Estimate Query Cost

``` r
\dontrun{
est <- flowfabric_streamflow_estimate(
  dataset_id = "nwm-forecast",
  params = list(issue_time = "latest", scope = "features", feature_ids = c("101"))
)
est
}
```

## Query Streamflow Data

``` r
\dontrun{
tbl <- flowfabric_streamflow_query(
  dataset_id = "nwm-forecast",
  params = list(issue_time = "latest", scope = "features", feature_ids = c("101"))
)
as.data.frame(tbl)
}
```
