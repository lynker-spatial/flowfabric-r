# Query stage data (Arrow IPC)

Query stage data (Arrow IPC)

## Usage

``` r
flowfabric_stage_query(
  dataset_id,
  params = NULL,
  token = NULL,
  ...,
  verbose = FALSE
)
```

## Arguments

- dataset_id:

  Dataset identifier

- params:

  List of query parameters (see API docs)

- token:

  Optional. Bearer token. If NULL, will use flowfabric_get_token().

- ...:

  Optional. Additional parameters (passed as named list)

- verbose:

  Optional. Use TRUE for debugging purposes

## Value

An Arrow Table

## Examples

``` r
if (FALSE) { # \dontrun{
tbl <- flowfabric_stage_query(
  dataset_id = "usgs-nwis-stage",
  params = list(feature_ids = c("101"))
)
df <- as.data.frame(tbl)
} # }
```
