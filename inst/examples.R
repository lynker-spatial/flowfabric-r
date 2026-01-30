devtools::load_all('.')
devtools::document()
options(flowfabric.api_url = "https://flowfabric-api.lynker-spatial.com")
(cat = flowfabric_list_datasets())
options(flowfabric.api_url = "http://127.0.0.1:8000")


#json <- '{"query_mode":"run","feature_ids":["101"],"issue_time":"2026012115","scope":"features","lead_start":0,"lead_end":0,"format":"arrow"}'

#cmd <- glue::glue(
#  "curl -v 'http://127.0.0.1:8000/v1/datasets/nws_owp_nwm_analysis/streamflow' \\
#  -H 'Authorization: Bearer {token}' \\
#  -H 'Content-Type: application/json' \\
#  -d '{json}'"
#)



system.time({
 result <- flowfabric_streamflow_query(
    "nws_owp_nwm_analysis",
    feature_ids = c("101", "1001"),
    issue_time = "latest"
  )
})
result

system.time({
  result <- flowfabric_streamflow_query(
      "lynker_spatial_ecwmf_glofas_global",
      issue_time = "latest"
  )
})

system.time({
  result <- flowfabric_streamflow_query(
    "nws_owp_nwm_short_range",
    issue_time = "latest"
  )
})
result


system.time({
  result <- flowfabric_streamflow_query(
    "nws_owp_nwm_reanalysis_3_0",
    feature_ids = c("101", "1001"),
    start_time = "2018-01-01",
    end_time = "2018-01-31"
  )
})
result
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
estimate <- flowfabric_ratings_query(
  feature_ids = c("101", "1001"),
  type = "rem",
  format = "json"
)
print(estimate)

# List features for a dataset
features <- flowfabric_get("/v1/datasets/nws_owp_nwm_analysis/features")
print(features)

# Get metadata for a dataset
metadata <- flowfabric_get("/v1/datasets/nws_owp_nwm_analysis/metadata")
print(metadata)

# Get catalog info for a dataset
catalog <- flowfabric_get("/v1/datasets/nws_owp_nwm_analysis/catalog")
print(catalog)

