vnstockr package
================
Haivo
2021-10-04

This is a simple package that allow user to get the Vietnam stock datas
from cafef.vn and vndirect.

# Install

To install this package, use:

``` r
devtools::install_github("https://github.com/vohai611/vnstockr")
```

# Usage

This package only contain two function `get_cafeF()` and
`get_vndirect()`. User just need to specify stock code (symbol) and time
frame. For example:

``` r
library(vnstockr)
get_vndirect('ACB', '1/1/2021', '1/12/2021')
```

    ## # A tibble: 186 × 25
    ##    code  date       time    floor type  basicPrice ceilingPrice floorPrice  open
    ##    <chr> <date>     <chr>   <chr> <chr>      <dbl>        <dbl>      <dbl> <dbl>
    ##  1 ACB   2021-10-04 14:44:… HOSE  STOCK       31.5         33.7       29.3  31.3
    ##  2 ACB   2021-10-01 15:10:… HOSE  STOCK       31.6         33.8       29.4  31.5
    ##  3 ACB   2021-09-30 15:09:… HOSE  STOCK       31.4         33.5       29.2  31.4
    ##  4 ACB   2021-09-29 15:09:… HOSE  STOCK       31.6         33.8       29.4  31.6
    ##  5 ACB   2021-09-28 15:09:… HOSE  STOCK       31.5         33.7       29.3  31.5
    ##  6 ACB   2021-09-27 15:09:… HOSE  STOCK       32           34.2       29.8  32.2
    ##  7 ACB   2021-09-24 15:09:… HOSE  STOCK       31.6         33.8       29.4  31.8
    ##  8 ACB   2021-09-23 15:09:… HOSE  STOCK       31.6         33.8       29.4  31.7
    ##  9 ACB   2021-09-22 15:09:… HOSE  STOCK       31.8         34         29.6  31.8
    ## 10 ACB   2021-09-21 15:09:… HOSE  STOCK       32.1         34.3       29.9  31.8
    ## # … with 176 more rows, and 16 more variables: high <dbl>, low <dbl>,
    ## #   close <dbl>, average <dbl>, adOpen <dbl>, adHigh <dbl>, adLow <dbl>,
    ## #   adClose <dbl>, adAverage <dbl>, nmVolume <dbl>, nmValue <dbl>,
    ## #   ptVolume <dbl>, ptValue <dbl>, change <dbl>, adChange <dbl>,
    ## #   pctChange <dbl>

# Note

`get_cafeF()` use POST request to cafef.vn, hence the speed is much
slower than `get_vndirect()`. It also have high chance of break in the
future.

Package now include function `get_cafeF2()` which using async request
(from `{crulx}` package). The new function might be twice as fast
compare with the old one.

Below is the benchmark of these two:

``` r
# get_cafeF
system.time(
get_cafeF("ACB", "1/1/2020", "1/1/2021")
)
```

    ##    user  system elapsed 
    ##   0.867   0.062  14.338

``` r
#get_cafeF2
system.time(
  get_cafeF2("ACB", "1/1/2020", "1/1/2021")
)
```

    ##    user  system elapsed 
    ##   0.927   0.027   4.913
