
# flowfabricr: Effortless R Access to FlowFabric API

`flowfabricr` is a powerful R client for the FlowFabric API, providing seamless access to hydrologic forecasts, reanalysis, rating curves, and datasets. With robust authentication and automatic token caching, you can focus on data science, not on data munging plumbing. 

See flowfabric working live here: https://flowfabric-live.lynker-spatial.com 

## Key Features
- **Evolving catalog** of harmonized data from multiple models
- **Single method access** to all models - both retrospective and forecast
- **One-time authentication**: Log in once, and your token is cached for future use.
- **Arrow IPC support**: Fast, memory-efficient data transfer

## Installation
```r
#  Install from GitHub:
devtools::install_github('lynker-spatial/flowfabric-r')
```

## Quick Start
```r
library(flowfabricr)

# 1. List available datasets
datasets <- flowfabric_list_datasets()
head(datasets)

# 2. Query streamflow forecast (first call prompts login, then caches token)
# More on atuhentication below ...
tbl <- flowfabric_streamflow_query(
	dataset_id = "nws_owp_nwm_analysis",
	feature_ids = c("101", "1001"),
	issue_time = "latest"
)
head(tbl)

# 3. Query streamflow reanalysis data
tbl_re <- flowfabric_streamflow_query(
  "nws_owp_nwm_reanalysis_3_0",
  feature_ids = c("101", "179", "1001"),
  start_time = "2018-01-01",
  end_time = "2018-01-31"
)
head(tbl_re)

# 4. Query ratings
ratings <- flowfabric_ratings_query(
    feature_ids = c("101", "1001"), 
    type = "rem"
)
```

## Authentication & Token Caching

Using this platform requires authentication via the Lynker Spatial Portal (https://lynker-spatial.com/). Accounts are free to set up and use. If use exceeds costs we can burden we will reach out to power users to better understand how we can help.

To get access, users can create an account here: https://proxy.lynker-spatial.com/

The first API call will prompt you to log in via browser. Your token is then cached and reused for all future calls—no repeated browser prompts!

**Manual token refresh:**
```r
flowfabric_refresh_token() # Forces re-authentication and updates cached token
```

**Advanced:**
You can always pass a token explicitly:
```r
token <- hfutils::lynker_spatial_auth()$id_token
tbl <- flowfabric_streamflow_query("nws_owp_nwm_analysis", feature_ids = c("101"), token = token)
```

## Troubleshooting
- If you see repeated browser prompts, call `flowfabric_refresh_token()` once, then retry your queries.
- If you switch users, manually refresh the token.
- Use `verbose = TRUE` in any endpoint for detailed debug output.

## Learn More
- See the [vignettes](articles/index.md) for advanced usage, authentication, and custom queries.
- All API responses are Arrow tables for high-performance analytics.
