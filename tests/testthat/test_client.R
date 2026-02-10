library(testthat)
library(flowfabricr)

# Test for flowfabric_list_datasets

test_that("flowfabric_list_datasets returns a data frame", {
  result <- flowfabric_list_datasets()
  expect_s3_class(result, "data.frame")
})

# Test for flowfabric_get_dataset

test_that("flowfabric_get_dataset returns a list", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_reanalysis_3_0"
  result <- flowfabric_get_dataset(dataset_id, token)
  expect_type(result, "list")
})

# Test for flowfabric_get_latest_run

test_that("flowfabric_get_latest_run returns a list", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_get_latest_run(dataset_id, token)
  expect_type(result, "list")
})

# Test for flowfabric_streamflow_estimate

test_that("flowfabric_streamflow_estimate returns a list", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_streamflow_estimate(dataset_id, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_streamflow_query

test_that("flowfabric_streamflow_query returns a data frame", {
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_streamflow_query(dataset_id)
  expect_s3_class(result, "data.frame")
})

# Test for flowfabric_ratings_query

test_that("flowfabric_ratings_query returns a list", {
  token <- get_bearer_token()
  feature_ids <- c("101", "1001")
  result <- flowfabric_ratings_query(feature_ids, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_ratings_estimate
test_that("flowfabric_ratings_estimate returns a list", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_ratings_estimate(dataset_id, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_stage_query

test_that("flowfabric_stage_query returns an Arrow Table", {
  token <- get_bearer_token()
  dataset_id <- "usgs_nwis_stage"
  params <- list(param1 = "value1")
  result <- flowfabric_stage_query(dataset_id, params, token = token)
  expect_s3_class(result, "ArrowTable")
})

# Test for flowfabric_healthz

test_that("flowfabric_healthz returns a list", {
  token <- get_bearer_token()
  result <- flowfabric_healthz(token = token)
  expect_type(result, "list")
})

# Test for get_bearer_token

test_that("get_bearer_token returns a string", {
  token <- get_bearer_token()
  expect_type(token, "character")
})