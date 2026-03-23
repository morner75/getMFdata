
<!-- README.md is generated from README.Rmd. Please edit that file -->

# getMFdata

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/morner75/getMFdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/morner75/getMFdata/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`getMFdata` is an R package for retrieving macro-financial data from
Korean public institutions and international organizations through their
official APIs.

| Source    | Organization                                           | Auth             |
|-----------|--------------------------------------------------------|------------------|
| **ECOS**  | Bank of Korea (한국은행)                               | API key required |
| **FISIS** | Financial Supervisory Service (금융감독원)             | API key required |

Originally developed for stress-testing workflows at the Financial
Supervisory Service, the package aims to provide a consistent interface
across heterogeneous data sources.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("morner75/getMFdata")
```

## API Keys

ECOS and FISIS require API keys. Store them in your `.Renviron` file so
they are available across sessions:

``` r
# Open .Renviron for editing
usethis::edit_r_environ()
```

Add the following lines and restart R:

    ECOS_key=your_ecos_key_here
    FISIS_key=your_fisis_key_here

- **ECOS key**: register at <https://ecos.bok.or.kr/api/>
- **FISIS key**: register at <https://fisis.fss.or.kr/openapi/>

------------------------------------------------------------------------

## ECOS — Bank of Korea

``` r
library(getMFdata)
library(dplyr)

ECOS_key <- Sys.getenv("ECOS_key")
```

### Search for statistics codes

`ecosSearch()` searches across ~52,000 item entries (Korean and English
names) bundled with the package — no API call needed.

``` r
# Find codes related to GDP
ecosSearch("GDP") |> select(STAT_CODE, STAT_NAME, ITEM_CODE, ITEM_NAME, CYCLE) |> head(5)
#> # A tibble: 5 × 5
#>   STAT_CODE STAT_NAME                   ITEM_CODE ITEM_NAME                CYCLE
#>   <chr>     <chr>                       <chr>     <chr>                    <chr>
#> 1 200Y101   2.1.1.1. 주요지표(연간지표) 10107     1인당 국내총생산(명목, 원화표시)…… A    
#> 2 200Y101   2.1.1.1. 주요지표(연간지표) 1010701   1인당 국내총생산(명목, 달러표시)…… A    
#> 3 200Y101   2.1.1.1. 주요지표(연간지표) 90103     GDP 디플레이터           A    
#> 4 200Y102   2.1.1.2. 주요지표(분기지표) 10111     국내총생산(GDP)(실질, 계절조정, 전기… Q    
#> 5 200Y102   2.1.1.2. 주요지표(분기지표) 10112     비농림어업GDP            Q
```

``` r
# Korean keyword search
ecosSearch("소비자물가") |> select(STAT_CODE, STAT_NAME, ITEM_CODE, ITEM_NAME, CYCLE) |> head(5)
#> # A tibble: 5 × 5
#>   STAT_CODE STAT_NAME             ITEM_CODE ITEM_NAME            CYCLE
#>   <chr>     <chr>                 <chr>     <chr>                <chr>
#> 1 901Y009   4.2.1. 소비자물가지수 0         총지수               A    
#> 2 901Y009   4.2.1. 소비자물가지수 0         총지수               M    
#> 3 901Y009   4.2.1. 소비자물가지수 0         총지수               Q    
#> 4 901Y009   4.2.1. 소비자물가지수 A         식료품 및 비주류음료 A    
#> 5 901Y009   4.2.1. 소비자물가지수 A         식료품 및 비주류음료 M
```

### Browse available statistics tables

``` r
# Returns all ~600 statistics tables
getEcosList(ECOS_key)
```

### Inspect item codes for a table

``` r
# Item structure for table 722Y001 (BOK base rate and lending/deposit rates)
getEcosCode(ECOS_key, "722Y001") |> select(ITEM_CODE, ITEM_NAME, CYCLE, START_TIME, END_TIME)
#> # A tibble: 48 × 5
#>    ITEM_CODE ITEM_NAME         CYCLE START_TIME END_TIME
#>    <chr>     <chr>             <chr> <chr>      <chr>   
#>  1 0101000   한국은행 기준금리 A     1999       2025    
#>  2 0101000   한국은행 기준금리 D     19990506   20260320
#>  3 0101000   한국은행 기준금리 M     199905     202602  
#>  4 0101000   한국은행 기준금리 Q     1999Q2     2025Q4  
#>  5 0102000   정부대출금금리    A     1994       2025    
#>  6 0102000   정부대출금금리    D     19940103   20260310
#>  7 0102000   정부대출금금리    M     199401     202602  
#>  8 0102000   정부대출금금리    Q     1994Q1     2025Q4  
#>  9 0109000   총액한도대출금리  A     1994       2012    
#> 10 0109000   총액한도대출금리  D     19940315   20250705
#> # ℹ 38 more rows
```

### Retrieve data

`getEcosData()` returns a two-column tibble of `TIME` and `DATA_VALUE`.

``` r
# BOK base rate, monthly, 2020–2024
getEcosData(ECOS_key, "722Y001", "M", "202001", "202412", "0101000", "", "")
#>      TIME DATA_VALUE
#> 1  202001       1.25
#> 2  202002       1.25
#> 3  202003       0.75
#> 4  202004       0.75
#> 5  202005        0.5
#> 6  202006        0.5
#> 7  202007        0.5
#> 8  202008        0.5
#> 9  202009        0.5
#> 10 202010        0.5
#> 11 202011        0.5
#> 12 202012        0.5
#> 13 202101        0.5
#> 14 202102        0.5
#> 15 202103        0.5
#> 16 202104        0.5
#> 17 202105        0.5
#> 18 202106        0.5
#> 19 202107        0.5
#> 20 202108       0.75
#> 21 202109       0.75
#> 22 202110       0.75
#> 23 202111          1
#> 24 202112          1
#> 25 202201       1.25
#> 26 202202       1.25
#> 27 202203       1.25
#> 28 202204        1.5
#> 29 202205       1.75
#> 30 202206       1.75
#> 31 202207       2.25
#> 32 202208        2.5
#> 33 202209        2.5
#> 34 202210          3
#> 35 202211       3.25
#> 36 202212       3.25
#> 37 202301        3.5
#> 38 202302        3.5
#> 39 202303        3.5
#> 40 202304        3.5
#> 41 202305        3.5
#> 42 202306        3.5
#> 43 202307        3.5
#> 44 202308        3.5
#> 45 202309        3.5
#> 46 202310        3.5
#> 47 202311        3.5
#> 48 202312        3.5
#> 49 202401        3.5
#> 50 202402        3.5
#> 51 202403        3.5
#> 52 202404        3.5
#> 53 202405        3.5
#> 54 202406        3.5
#> 55 202407        3.5
#> 56 202408        3.5
#> 57 202409        3.5
#> 58 202410       3.25
#> 59 202411          3
#> 60 202412          3
```

### Format date parameters with `EcosTerm()`

`EcosTerm()` converts R date objects to the period strings ECOS expects.

``` r
EcosTerm(Sys.Date(), "A")   # annual:    e.g. "2026"
#> [1] "2026"
EcosTerm(Sys.Date(), "Q")   # quarterly: e.g. "2026Q1"
#> [1] "2026Q1"
EcosTerm(Sys.Date(), "M")   # monthly:   e.g. "202603"
#> [1] "202603"
EcosTerm(Sys.Date(), "D")   # daily:     e.g. "20260322"
#> [1] "20260322"
```

------------------------------------------------------------------------

## FISIS — Financial Supervisory Service

FISIS provides balance sheet and income statement data for Korean
financial institutions.

``` r
FISIS_key <- Sys.getenv("FISIS_key")

# List financial institutions
getFsisInfos(FISIS_key, "companySearch")

# List available statistics
getFsisInfos(FISIS_key, "statisticsListSearch", item_code = "A")

# Retrieve bank balance sheet data (annual, 2015–2023)
getFsisData(FISIS_key,
            finance_cd  = "0010001",  # all banks
            list_no     = "SA053",    # balance sheet
            account_cd  = "B",
            term        = "Y",
            start_month = "201501",
            end_month   = "202312")
```

------------------------------------------------------------------------

## Bundled dataset

`usdkrw` — monthly average USD/KRW exchange rate from January 1990 to
the present, loaded lazily.

``` r
head(usdkrw)
#>    yearmon usdkrw
#> 1 1990.000 683.43
#> 2 1990.083 689.87
#> 3 1990.167 697.78
#> 4 1990.250 706.03
#> 5 1990.333 709.26
#> 6 1990.417 715.33
tail(usdkrw)
#>      yearmon  usdkrw
#> 405 2023.667 1329.47
#> 406 2023.750 1350.69
#> 407 2023.833 1310.39
#> 408 2023.917 1303.98
#> 409 2024.000 1323.57
#> 410 2024.083 1331.74
```
