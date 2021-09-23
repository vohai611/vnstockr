vnstockr package
================
Haivo
7/21/2021

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

    ## # A tibble: 136 x 25
    ##    code  date       time    floor type  basicPrice ceilingPrice floorPrice  open
    ##    <chr> <date>     <chr>   <chr> <chr>      <dbl>        <dbl>      <dbl> <dbl>
    ##  1 ACB   2021-07-22 14:44:… HOSE  STOCK       33.8         36.2       31.4  33.8
    ##  2 ACB   2021-07-21 15:07:… HOSE  STOCK       33.9         36.2       31.6  34.0
    ##  3 ACB   2021-07-20 15:07:… HOSE  STOCK       32.2         34.4       29.9  32.5
    ##  4 ACB   2021-07-19 15:07:… HOSE  STOCK       33.6         36.0       31.2  32.9
    ##  5 ACB   2021-07-16 15:07:… HOSE  STOCK       32.8         35         30.5  33.2
    ##  6 ACB   2021-07-15 15:07:… HOSE  STOCK       31.8         34.0       29.6  31.4
    ##  7 ACB   2021-07-14 15:07:… HOSE  STOCK       32.9         35.2       30.6  32.9
    ##  8 ACB   2021-07-13 15:07:… HOSE  STOCK       32.8         35         30.5  33.3
    ##  9 ACB   2021-07-12 15:07:… HOSE  STOCK       35.2         37.6       32.8  34.5
    ## 10 ACB   2021-07-09 15:07:… HOSE  STOCK       36.2         38.7       33.7  36  
    ## # … with 126 more rows, and 16 more variables: high <dbl>, low <dbl>,
    ## #   close <dbl>, average <dbl>, adOpen <dbl>, adHigh <dbl>, adLow <dbl>,
    ## #   adClose <dbl>, adAverage <dbl>, nmVolume <dbl>, nmValue <dbl>,
    ## #   ptVolume <dbl>, ptValue <dbl>, change <dbl>, adChange <dbl>,
    ## #   pctChange <dbl>

# Note

`get_cafeF()` use POST request to cafef.vn, hence the speed is much
slower than `get_vndirect()`. It also have high chance of break in the
future.
