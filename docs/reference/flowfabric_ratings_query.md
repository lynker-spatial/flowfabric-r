# Query REM ratings (stage-discharge relationships)

Query REM ratings (stage-discharge relationships)

## Usage

``` r
flowfabric_ratings_query(
  feature_ids,
  type = "rem",
  format = "arrow",
  token = NULL,
  ...,
  verbose = FALSE
)
```

## Arguments

- feature_ids:

  Character vector of feature IDs (required)

- type:

  Ratings type: 'rem' (default) or 'ahps'

- format:

  Output format: 'arrow' (default), 'json', or 'parquet'

- token:

  Optional. Bearer token. If NULL, will use flowfabric_get_token().

- ...:

  Additional parameters (passed as named list)

- verbose:

  Use TRUE for debugging purposes

## Value

Parsed response (Arrow Table, data.frame, or list depending on format)

## Examples

``` r
if (FALSE) { # \dontrun{
ratings <- flowfabric_ratings_query(feature_ids = c("101", "1001"), type = "rem")
} # }
```
