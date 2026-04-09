library(testthat)
library(flowfabricr)

# Test flowfabric_get() for response type

test_that("flowfabric_get returns a httr2 response object", {
  skip_on_cran()
  skip_on_ci()
  token <- get_bearer_token()
  endpoint <- "/v1/datasets"
  result <- flowfabric_get(endpoint, token = token)
  expect_s3_class(result, "httr2_response")
})

