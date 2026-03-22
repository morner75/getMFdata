# inst/Rdata/

This directory should contain `EcosStatsList.rds`, which is required by `ecosSearch()`.

## How to generate EcosStatsList.rds

Run the following once with a valid ECOS API key to build and save the search index:

```r
library(getMFdata)
library(dplyr)
library(purrr)

key <- Sys.getenv("ECOS_key")

# Get all statistics tables
stat_list <- getEcosList(key)

# For each stat table, retrieve item codes and bind together
ecos_stats <- stat_list$STAT_CODE %>%
  map_dfr(function(code) {
    tryCatch(getEcosCode(key, code), error = function(e) NULL)
  })

# Save to inst/Rdata/
saveRDS(ecos_stats, "inst/Rdata/EcosStatsList.rds")
```

After saving, reinstall the package with `devtools::install()` so `system.file()` can locate the file.
