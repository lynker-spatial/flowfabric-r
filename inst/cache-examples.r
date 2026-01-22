devtools::load_all('.')

options(flowfabric.api_url = "https://flowfabric-api.lynker-spatial.com")


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

get_bearer_token(force_refresh = TRUE)
result_cached <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  feature_ids = c("101", "1001"),
  issue_time = "latest"
)


print(result_cached)
# ---- End Token Caching Test ----
