library(testthat)
library(flowfabricr)

# Test for flowfabric_list_datasets

test_that("flowfabric_list_datasets returns a data frame", {
  skip_on_cran()
  skip_on_ci()
  result <- flowfabric_list_datasets()
  expect_s3_class(result, "data.frame")
})

# Test for flowfabric_get_dataset

test_that("flowfabric_get_dataset returns a list", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_reanalysis_3_0"
  result <- flowfabric_get_dataset(dataset_id, token)
  expect_type(result, "list")
})

# Test for flowfabric_get_latest_run

test_that("flowfabric_get_latest_run returns a list", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_get_latest_run(dataset_id, token)
  expect_type(result, "list")
})

# Test for flowfabric_streamflow_estimate

test_that("flowfabric_streamflow_estimate returns a list", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_streamflow_estimate(dataset_id, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_streamflow_query

test_that("flowfabric_streamflow_query returns a data frame", {
  skip_on_cran()
  skip_on_ci()
  dataset_id <- "nws_owp_nwm_analysis"
  result <- flowfabric_streamflow_query(dataset_id)
  expect_s3_class(result, "data.frame")
})

# Test for flowfabric_ratings_query

test_that("flowfabric_ratings_query returns a list", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  feature_ids <- c("101", "1001")
  result <- flowfabric_ratings_query(feature_ids, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_healthz

test_that("flowfabric_healthz returns a list", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  result <- flowfabric_healthz(token = token)
  expect_type(result, "list")
})

# Test for get_bearer_token

test_that("get_bearer_token returns a string", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  expect_type(token, "character")
})