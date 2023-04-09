
<!-- README.md is generated from README.Rmd. Please edit that file -->

# getMFdata

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/morner75/getMFdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/morner75/getMFdata/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

### Retrieving macro-financial data from offical APIs

The goal of the `getMFdata` package is to facilitate the retrieval of
Macro-Finance data from official APIs in Korea’s public institutions and
international organizations. The package currently consists of main
wrapper functions that enable connection to **ECOS** (Bank of Korea),
**FISIS** (Financial Supervisory Service), **KOSIS** (Statistics Korea),
**FRED** (Federal Reserve Bank of St. Louis), **IMF** (International
Monetary Fund), **OECD** (Organization for Economic Co-operation and
Development), and **BIS** (Bank of International Settlement).

Initially developed for internal use in the Financial Supervisory
Service to fetch macroeconomic data for stress-testing, the `getMFdata`
package is still under development and aims to balance ease of use with
flexibility to accommodate various data structures.

### Installation

To install the package, please follow standard R package installation
procedures.

``` r
library(devtools)
install_github("morner75/getMFdata")
```

### Example

The following are basic examples which show you how to retrieve data
from BOK and BIS sources. Some sources requires your API authentication
before you can get access to data.

``` r
library(getMFdata)
library(stringr)
suppressMessages(library(dplyr))

## 1. BOK ECOS data

# ECOS API key
ECOS_key <- Sys.getenv(x="ECOS_key")

# Retrieve data 
# data : 200Y001 국민소득통계 연간지표 실질경제성장율
ecos_df <- getEcosData(ECOS_key,"200Y001","A", "1980","2022", "20101","?","?")
head(ecos_df)
#>   TIME DATA_VALUE
#> 1 1980       -1.6
#> 2 1981        7.2
#> 3 1982        8.3
#> 4 1983       13.4
#> 5 1984       10.6
#> 6 1985        7.8


## 2. BIS data

# get BIS database
bisDB <- getBisDB()  

# Retrieve data : consumer price
bisData <-        
  bisDB %>% 
  filter(name=="Consumer prices") %>% 
  pull() %>% 
  getBisData()

# Data processing 
CPI <- bisData %>% 
  filter(str_detect(Series,"^A.+771$")) %>% 
  select(REF_AREA, `Reference area`, matches("^20[0-9]{2}$"))

head(CPI)
#> # A tibble: 6 × 25
#>   REF_A…¹ Refer…² `2000` `2001` `2002` `2003` `2004` `2005` `2006` `2007` `2008`
#>   <chr>   <chr>    <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#> 1 AE      United…  1.35    2.81   2.87   3.07   5.01   6.19   9.36  11.1   12.3 
#> 2 AR      Argent… -0.939  -1.07  25.9   13.4    4.42   9.64  10.9    8.83   8.58
#> 3 AT      Austria  2.38    2.68   1.79   1.36   2.08   2.29   1.45   2.16   3.21
#> 4 AU      Austra…  4.46    4.41   2.98   2.73   2.34   2.69   3.56   2.33   4.35
#> 5 BE      Belgium  2.54    2.47   1.65   1.59   2.10   2.78   1.79   1.82   4.49
#> 6 BG      Bulgar… 10.3     7.36   5.81   2.35   6.15   5.04   7.26   8.40  12.3 
#> # … with 14 more variables: `2009` <dbl>, `2010` <dbl>, `2011` <dbl>,
#> #   `2012` <dbl>, `2013` <dbl>, `2014` <dbl>, `2015` <dbl>, `2016` <dbl>,
#> #   `2017` <dbl>, `2018` <dbl>, `2019` <dbl>, `2020` <dbl>, `2021` <dbl>,
#> #   `2022` <dbl>, and abbreviated variable names ¹​REF_AREA, ²​`Reference area`
```
