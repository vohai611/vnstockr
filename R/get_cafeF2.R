#' Get stock data from cafef.vn with asynch request
#'
#' get_cafeF2() is now using asynchronous request from `crul` package to improve speed. The function now is
#' twice as fast as the old one.
#' @param symbol the code of stock, for example 'VCB', 'ACB'
#' @param start_date the start date, in the form DD/MM/YYYY
#' @param end_date the end date, in the form DD/MM/YYYY
#' @return A tibble contain all stock data in that period
#' @import dplyr
#' @import lubridate
#' @import crul
#' @export

get_cafeF2 = function(symbol, start_date = NULL, end_date = NULL) {
  . = NULL
  ngay = NULL
  # set default argument
  if(is.null(start_date)) start_date = format(today()-15, "%d-%m-%Y")
  if(is.null(end_date)) end_date = format(today(), "%d-%m-%Y")

  if(dmy(end_date) - dmy(start_date) <= 0) {
    stop("end_date must be after start_date")
  }


  url =  "https://s.cafef.vn/Lich-su-giao-dich-VNG-1.chn"

  # close connection
  on.exit(close(url(url, 'rb')), add = TRUE)

  # provide POST request body for each page
  get_page_body = function(page) {
    list(
      `ctl00$ContentPlaceHolder1$scriptmanager` = "ctl00$ContentPlaceHolder1$ctl03$panelAjax|ctl00$ContentPlaceHolder1$ctl03$pager2",
      `ctl00$ContentPlaceHolder1$ctl03$txtKeyword` = symbol,
      `ctl00$ContentPlaceHolder1$ctl03$dpkTradeDate1$txtDatePicker` = start_date,
      `ctl00$ContentPlaceHolder1$ctl03$dpkTradeDate2$txtDatePicker` = end_date,
      `ctl00$UcFooter2$hdIP` = NULL,
      `__EVENTTARGET` =  "ctl00$ContentPlaceHolder1$ctl03$pager2",
      `__EVENTARGUMENT` = page,
      `__VIEWSTATE` = form_cafef$fields$`__VIEWSTATE`$value,
      `__VIEWSTATEGENERATOR` = form_cafef$fields$`__VIEWSTATEGENERATOR`$value,
      `__ASYNCPOST:` = "true")
  }

  # parse request result, might optimize later
  parse_table = function(.tbl) {
    .tbl %>% rvest::read_html() %>%
      rvest::html_table(header = TRUE) %>%
      .[[2]] %>%
      janitor::clean_names() %>%
      slice(-1) %>%
      select(-contains("kl_dot"),-contains("thay_doi_percent")) %>%
      mutate(ngay = lubridate::dmy(ngay)) %>%
      mutate(across(-ngay, readr::parse_number))
  }

  # count page
  result_row <-
    sum(!wday(seq(
      dmy(start_date), dmy(end_date), by = "day"
    )) %in% c(1, 7))

  total_page <- result_row %/% 20 + 1

  pages_number = seq_len(total_page)

  # create and make asynchronous request
  x = vector(mode = "list",total_page)
  names(x) <- paste0("req",pages_number)

  for (i in names(x)) {
    x[[i]] <-  HttpRequest$new(url)
  }

  purrr::walk2(x, seq_along(x),  ~{
    .x$post(body = get_page_body(.y))
  })

  res = AsyncVaried$new(.list = x)
  res$request()
  res$parse() %>%
    purrr::map(parse_table) %>%
    bind_rows()
}



