% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_vndirect.R
\name{get_vndirect}
\alias{get_vndirect}
\title{Get stock data from vndirect}
\usage{
get_vndirect(symbol, start_date = NULL, end_date = NULL)
}
\arguments{
\item{symbol}{the symbol of stock, for example 'VCB', 'ACB'}

\item{start_date}{the start date, in the form DD/MM/YYYY, default is 15 day ago from today}

\item{end_date}{the end_date, in the form DD/MM/YYYY, default is today}
}
\value{
A tibble contain all stock data from that period
}
\description{
Get stock data from vndirect
}
\examples{
get_vndirect("VIC", '1/1/2015', '1/1/2017')
}
