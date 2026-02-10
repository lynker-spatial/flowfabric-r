# Package index

## API Client

Core functions for interacting with the FlowFabric API.

- [`flowfabric_list_datasets()`](flowfabric_list_datasets.md) : List all
  available datasets
- [`flowfabric_streamflow_estimate()`](flowfabric_streamflow_estimate.md)
  : Estimate streamflow result size and get export_url when available
- [`flowfabric_streamflow_query()`](flowfabric_streamflow_query.md) :
  Query streamflow
- [`flowfabric_ratings_query()`](flowfabric_ratings_query.md) : Query
  REM ratings (stage-discharge relationships)
- [`flowfabric_stage_query()`](flowfabric_stage_query.md) : Query stage
  data (Arrow IPC)
- [`flowfabric_get_token()`](flowfabric_get_token.md) : Get a JWT Bearer
  Token for FlowFabric API
- [`flowfabric_token()`](flowfabric_token.md) : Manage global FlowFabric
  API token
- [`flowfabric_get_dataset()`](flowfabric_get_dataset.md) : Get dataset
  details from catalog
- [`flowfabric_get_latest_run()`](flowfabric_get_latest_run.md) : Get
  latest run for a dataset
- [`flowfabric_healthz()`](flowfabric_healthz.md) : Health check
- [`flowfabric_inundation_ids()`](flowfabric_inundation_ids.md) : Query
  inundation ids
- [`flowfabric_ratings_estimate()`](flowfabric_ratings_estimate.md) :
  Estimate size of ratings query
- [`get_bearer_token()`](get_bearer_token.md) : Retrieve Bearer Token
- [`flowfabricr`](flowfabricr-package.md)
  [`flowfabricr-package`](flowfabricr-package.md) : flowfabricr: R
  Client for FlowFabric API

## Catalog Utilities

- [`auto_streamflow_params()`](auto_streamflow_params.md) :
  Auto-populate streamflow query params from catalog

## HTTP Utilities

- [`flowfabric_get()`](flowfabric_get.md) : Perform a GET request to the
  FlowFabric API
- [`flowfabric_post()`](flowfabric_post.md) : Perform a POST request to
  the FlowFabric API

## Auth Utilities

- [`flowfabric_refresh_token()`](flowfabric_refresh_token.md) : Force
  refresh the token
