# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

`getMFdata` is an R package for retrieving macro-financial data from Korean public institutions. It wraps APIs from ECOS (Bank of Korea) and FISIS (FSS).

## Common Commands

```r
# Install dependencies and load package
devtools::install_deps()
devtools::load_all()

# Run tests
devtools::test()

# Generate documentation from Roxygen2 comments
devtools::document()

# Run R CMD check (same as CI)
devtools::check()

# Install package locally
devtools::install()
```

Run a single test file:
```r
testthat::test_file("tests/testthat/test-getEcosData.R")
```

## Architecture

All data source modules follow the same pattern:
1. Build API URL from parameters
2. HTTP GET via `httr`
3. Parse JSON/CSV response
4. Transform to tibble and return

### Data Sources & Key Functions

| Source | Functions |
|--------|-----------|
| ECOS (Bank of Korea) | `getEcosData()`, `getEcosList()`, `getEcosCode()`, `ecosSearch()`, `EcosTerm()` |
| FISIS (FSS) | `getFsisData()`, `getFsisInfos()` |

### API Authentication

- **ECOS**: requires `ECOS_key` environment variable (Bank of Korea API key)
- **FISIS**: `api_key` parameter passed directly to functions

### Notable Implementation Details

- **ECOS search** (`ecosSearch()`) reads from a pre-built RDS file at `Rdata/EcosStatsList.rds` rather than calling the API
- All Korean API responses require explicit UTF-8 encoding: `Encoding(res) <- "UTF-8"`
- Dates for ECOS use `EcosTerm()` to format period strings (annual/quarterly/monthly/daily)

### Bundled Dataset

`usdkrw` — monthly average USD/KRW exchange rate (Jan 1990–present), loaded lazily from `data/usdkrw.rda`.

## CI

GitHub Actions (`.github/workflows/R-CMD-check.yaml`) runs `R CMD check` on macOS, Windows, and Ubuntu across R devel/release/oldrel-1 on every push to main and on pull requests.
