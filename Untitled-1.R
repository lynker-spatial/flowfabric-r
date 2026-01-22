devtools::load_all('.')
#options(flowfabric.api_url = "https://flowfabric-api.lynker-spatial.com")
(cat = flowfabric_list_datasets())
#options(flowfabric.api_url = "http://127.0.0.1:8000")

#json <- '{"query_mode":"run","feature_ids":["101"],"issue_time":"2026012115","scope":"features","lead_start":0,"lead_end":0,"format":"arrow"}'

#cmd <- glue::glue(
#  "curl -v 'http://127.0.0.1:8000/v1/datasets/nws_owp_nwm_analysis/streamflow' \\
#  -H 'Authorization: Bearer {token}' \\
#  -H 'Content-Type: application/json' \\
#  -d '{json}'"
#)

#system(cmd)

params <- list(
  query_mode = "run",
  feature_ids = I(c("101")),
  issue_time = "latest",
  scope = "features",
  lead_start = 0,
  lead_end = 0,
  format = "arrow"
)
x = hfutils::lynker_spatial_auth()

result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  params = params,
  token = x$id_token
)

result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  params = params
)

result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  feature_ids = c("101", "1001"),
  issue_time = "latest"
)

result <- flowfabric_streamflow_query(
  "nws_owp_nwm_reanalysis_3_0",
  feature_ids = c("101", "1001"),
  start_time = "2018-01-01",
  end_time = "2018-01-31"
)
range(result$time)

## Uncomment and run interactively as needed:
# flowfabric_ratings_query()


ratings <- flowfabric_ratings_query(
  feature_ids = c("101", "1001"),
)

print(ratings)

# List all datasets
all_datasets <- flowfabric_list_datasets()
print(all_datasets)

# Query streamflow for a dataset
streamflow <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  feature_ids = c("101", "1001"),
  issue_time = "latest"
)
print(streamflow)

# Query stage data (if available)
stage <- flowfabric_stage_query(
  dataset_id = "usgs-nwis-stage",
  params = list(feature_ids = c("101"))
)
print(stage)

# Query ratings
ratings <- flowfabric_ratings_query(
  feature_ids = c("101", "1001"),
  type = "rem",
  format = "arrow"
)
print(ratings)

# Estimate ratings query size

print(estimate)

# ---- Token Caching Test ----
# 1. Get a token and cache it
cached_token <- get_bearer_token(force_refresh = TRUE)
cat("Token (cached):", cached_token, "\n")

# 2. Check if token file exists
cache_path <- file.path(Sys.getenv("HOME"), ".flowfabric_token")
cat("Token file exists:", file.exists(cache_path), "\n")

# 3. Read token from cache
if (file.exists(cache_path)) {
  cached_token_read <- readLines(cache_path, warn = FALSE)
  cat("Token (read from cache):", cached_token_read, "\n")
} else {
  cat("Token cache file not found!\n")
}

# 4. Use cached token for an API call
result_cached <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  params = params,
  token = cached_token_read
)
print(result_cached)
# ---- End Token Caching Test ----

