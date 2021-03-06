#' Get stock data from cafef.vn
#'
#' get_cafeF() is normally slower then get_vndirect(), because it trying to scrape data instead of
#' using the behind API
#' @param symbol the code of stock, for example 'VCB', 'ACB'
#' @param start_date the start date, in the form DD/MM/YYYY
#' @param end_date the end date, in the form DD/MM/YYYY
#' @return A tibble contain all stock data in that period
#' @export
#' @import dplyr
#' @import lubridate


get_cafeF <- function(symbol, start_date = NULL , end_date = NULL) {

  # set default argument
  if(is.null(start_date)) start_date = format(today()-15, "%d-%m-%Y")
  if(is.null(end_date)) end_date = format(today(), "%d-%m-%Y")

  # check valid time
  if(dmy(end_date) - dmy(start_date) <= 0) {
    stop("end_date must be after start_date")
  }

  ngay <- NULL
  link <- "https://s.cafef.vn/Lich-su-giao-dich-VNG-1.chn"

  result_row <-
    sum(!wday(seq(
      dmy(start_date), dmy(end_date), by = "day"
    )) %in% c(1, 7))

  total_page <- result_row %/% 20 + 1

  get_page <- function(symbol, start_date , end_date , page) {
    request <-   httr::POST(
      link,
      body = list(
        `ctl00$ContentPlaceHolder1$scriptmanager` = "ctl00$ContentPlaceHolder1$ctl03$panelAjax|ctl00$ContentPlaceHolder1$ctl03$pager2",
        `ctl00$ContentPlaceHolder1$ctl03$txtKeyword` = symbol,
        `ctl00$ContentPlaceHolder1$ctl03$dpkTradeDate1$txtDatePicker` = start_date,
        `ctl00$ContentPlaceHolder1$ctl03$dpkTradeDate2$txtDatePicker` = end_date,
        `ctl00$UcFooter2$hdIP` = NULL,
        `__EVENTTARGET` =  "ctl00$ContentPlaceHolder1$ctl03$pager2",
        `__EVENTARGUMENT` = page,
        `__VIEWSTATE` = form_cafef$fields$`__VIEWSTATE`$value,
        `__VIEWSTATEGENERATOR` = form_cafef$fields$`__VIEWSTATEGENERATOR`$value,
        `__ASYNCPOST:` = "true"
      )
    )
    ## parse request to tibble
    x <- request %>%
      rvest::read_html() %>%
      rvest::html_table(header = TRUE)

    x[[2]] %>%
      janitor::clean_names() %>%
      slice(-1) %>%
      select(-contains("kl_dot"),-contains("thay_doi_percent")) %>%
      mutate(ngay = lubridate::dmy(ngay)) %>%
      mutate(across(-ngay, readr::parse_number))
  }

  future::plan(future::multisession, workers = future::availableCores()-1)
  result <-  furrr::future_map_dfr(seq_len(total_page),
                                   ~ get_page(symbol, start_date, end_date, .x),
                                   .progress = TRUE)


  # to close connection after leave function
  on.exit(close(url(link, 'rb')), add = TRUE)

  return(result)
}
