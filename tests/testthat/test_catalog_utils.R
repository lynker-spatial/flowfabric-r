library(testthat)
library(flowfabricr)

# test auto_streamflow_params() for return type
test_that("auto_streamflow_params returns a list", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_reanalysis_3_0"
  result <- auto_streamflow_params(dataset_id)
  expect_type(result, "list")
})
