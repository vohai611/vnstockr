link =  "https://s.cafef.vn/Lich-su-giao-dich-VNG-1.chn"
form_cafef <- rvest::read_html(link) %>%
  rvest::html_form()
