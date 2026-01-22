
# flowfabricr: Effortless R Access to FlowFabric API

`flowfabricr` is a powerful R client for the FlowFabric API, providing seamless access to streamflow forecasts, reanalysis, ratings, and datasets. With robust authentication and automatic token caching, you can focus on data science, not on API plumbing.

## Key Features
- **One-time authentication**: Log in once, and your token is cached for future use.
- **Easy access to streamflow forecasts, reanalysis, and ratings**
- **List and explore available datasets**
- **Arrow IPC support**: Fast, memory-efficient data transfer
- **Verbose mode for debugging**

## Installation
```r
# Not yet on CRAN. Install from GitHub:
devtools::install_github('lynker-spatial/flowfabric-r')
```

## Quick Start
```r
library(flowfabricr)

# 1. Query streamflow forecast (first call prompts login, then caches token)
tbl <- flowfabric_streamflow_query(
	dataset_id = "nwm-forecast",
	feature_ids = c("101", "1001"),
	issue_time = "latest"
)
df <- as.data.frame(tbl)
head(df)

# 2. Query streamflow reanalysis
tbl_re <- flowfabric_streamflow_query(
	dataset_id = "nws_owp_nwm_analysis",
	feature_ids = c("101"),
	issue_time = "latest"
)

# 3. Query ratings
ratings <- flowfabric_ratings_query(feature_ids = c("101", "1001"), type = "rem")

# 4. List available datasets
datasets <- flowfabric_list_datasets()
head(datasets)
```

## Authentication & Token Caching
The first API call will prompt you to log in via browser. Your token is then cached and reused for all future calls—no repeated browser prompts!

**Manual token refresh:**
```r
flowfabric_refresh_token() # Forces re-authentication and updates cached token
```

**Advanced:**
You can always pass a token explicitly:
```r
token <- hfutils::lynker_spatial_auth()$id_token
tbl <- flowfabric_streamflow_query("nwm-forecast", feature_ids = c("101"), token = token)
```

## Troubleshooting
- If you see repeated browser prompts, call `flowfabric_refresh_token()` once, then retry your queries.
- If you switch users, manually refresh the token.
- Use `verbose = TRUE` in any endpoint for detailed debug output.

## Learn More
- See the vignettes for advanced usage, authentication, and custom queries.
- All API responses are Arrow tables for high-performance analytics.
