#' Get stock data from vndirect
#'
#' @param symbol the symbol of stock, for example 'VCB', 'ACB'
#' @param start_date the start date, in the form DD/MM/YYYY, default is 15 day ago from today
#' @param end_date the end_date, in the form DD/MM/YYYY, default is today
#' @return A tibble contain all stock data from that period
#' @export
#' @examples get_vndirect("VIC", '1/1/2015', '1/1/2017')
#' @importFrom lubridate dmy


get_vndirect <- function(symbol, start_date = NULL, end_date = NULL) {


  if(is.null(start_date)) {start_date = lubridate::today() - 15} else start_date = dmy(start_date)
  if(is.null(end_date )) {end_date = lubridate::today()} else end_date = dmy(end_date)

  # check valid time
  if(end_date - start_date <= 0) {
    stop("end_date must be after start_date")
  }

  size <- as.double(end_date - start_date)

  url <- "https://finfo-api.vndirect.com.vn"

  # to close url after leaving function
  on.exit(close(url(url, 'rb')), add = TRUE)


  # path <- glue::glue("/v4/stock_prices?sort=date&q=code:{symbol}~date:gte:{start_date}~date:lte:{end_date}&size={size}&page=1")
  path <- paste0("/v4/stock_prices?sort=date&q=code:",symbol,"~date:gte:", start_date, "~date:lte:", end_date, "&size=",size,"&page=1")

  get_result <- httr::modify_url(url, path = path)  %>%
    httr::GET() %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()

  get_result$data %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(date = lubridate::ymd(date)) %>%
    return()
}

