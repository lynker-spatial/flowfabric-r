# Estimate size of ratings query

Estimate size of ratings query

## Usage

``` r
flowfabric_ratings_estimate(
  feature_ids,
  type = "rem",
  format = "json",
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

  Output format: 'json', or 'parquet'

- token:

  Optional. Bearer token. If NULL, will use flowfabric_get_token().

- ...:

  Additional parameters (passed as named list)

- verbose:

  Use TRUE for debugging purposes

## Value

Estimated rows, bytes, and would_exceed_limits (boolean)

## Examples

``` r
if (FALSE) { # \dontrun{
ratings <- flowfabric_ratings_estimate(feature_ids = c("101", "1001"), type = "rem")
} # }
```
