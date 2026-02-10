# Demo the functionality of the R client

# load the package
devtools::load_all('.')

# get list of all the available datasets
datasets <- flowfabric_list_datasets()
head(datasets)

# get information on a specific dataset
dataset <- flowfabric_get_dataset("nws_owp_nwm_analysis")
print(dataset)

# get the latest run from a dataset
result <- flowfabric_get_latest_run("nws_owp_nwm_analysis")

# query streamflow on specific features in a dataset
result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  feature_ids = c("101", "1001"),
  issue_time = "latest"
)
print(result)

# query streamflow for the entire dataset (~8 million obs.)
result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  issue_time = "latest"
)
print(result)

# query streamflow for the largest dataset (~50 million obs.) (with timer)
system.time({
  result <- flowfabric_streamflow_query(
    "nws_owp_nwm_short_range",
    issue_time = "latest"
  )
  print(result)
})

# query a reanalysis instead of forecast
result <- flowfabric_streamflow_query(
  "nws_owp_nwm_reanalysis_3_0",
  feature_ids = c("101", "179", "1001"),
  start_time = "2018-01-01",
  end_time = "2018-01-31"
)
print(result)

# auto-generate streamflow parameters
auto_params <- auto_streamflow_params("nws_owp_nwm_analysis")

# use the auto-generated streamflow parameters in a query
result <- flowfabric_streamflow_query(
  "nws_owp_nwm_analysis",
  params = auto_params
)
print(result)

summary(result)

# get part of the results based on feature_id and streamflow
result <- result[!is.na(result['streamflow']), ]
result <- result[result['feature_id'] < 100000, ] 
result <- result[result['streamflow'] > 1, ]

# estimate size of streamflow data
estimate <- flowfabric_streamflow_estimate(
  "nws_owp_nwm_analysis", 
  params = c(issue_time="latest")
)

# get ratings for desired features
ratings <- flowfabric_ratings_query(
  feature_ids = c("101", "1001")
)
print(ratings)

# check the health of the API
health <- flowfabric_healthz()
print(health)

# manually extract a bearer token (if needed)
x <- flowfabric_get_token()
print(x)

# force refresh token
x <- flowfabric_refresh_token()
print(x)
