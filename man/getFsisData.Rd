% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getFisisData.R
\name{getFsisData}
\alias{getFsisData}
\title{Function to retrieve financial data from the Financial Supervisory Service Information System (FSIS)}
\usage{
getFsisData(
  api_key = api_key,
  finance_cd = "0010001",
  list_no = "SA053",
  account_cd = "B",
  term = "Y",
  start_month = "200801",
  end_month = "202012"
)
}
\arguments{
\item{api_key}{API key for FSIS Open API (defaults to value of api_key variable)}

\item{finance_cd}{Financial institution code (defaults to "0010001" for banks)}

\item{list_no}{Financial data type code (defaults to "SA053" for bank balance sheets)}

\item{account_cd}{Account type code (defaults to "B" for balance sheet accounts)}

\item{term}{Time period for data (defaults to "Y" for annual data)}

\item{start_month}{Starting month for data (defaults to "200801" for January 2008)}

\item{end_month}{Ending month for data (defaults to "202012" for December 2020)}
}
\value{
a list with the requested financial data
}
\description{
This function retrieves financial data from the Financial Supervisory Service Information System (FSIS) using the FSIS Open API.
}
