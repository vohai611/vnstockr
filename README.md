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
vnstockr::get_vndirect('ACB', '1/1/2021', '1/12/2021')
vnstockr::get_cafeF('ACB', '1/1/2021', '1/12/2021')
```
