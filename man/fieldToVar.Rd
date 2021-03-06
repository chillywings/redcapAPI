% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fieldToVar.R
\name{fieldToVar}
\alias{fieldToVar}
\title{Convert a REDCap Data Field to an R Vector}
\usage{
fieldToVar(
  records,
  data_dict,
  factors = TRUE,
  dates = TRUE,
  checkbox_labels = FALSE
)
}
\arguments{
\item{records}{A data frame of records returned by \code{rc_export}}

\item{data_dict}{A data frame giving the data data_dictionary, as returned
by \code{exportMetaData}}

\item{factors}{Logical, determines if checkbox, radio button, dropdown and yesno
variables are converted to factors}

\item{dates}{Logical, determines if date variables are converted to POSIXct format}

\item{checkbox_labels}{Logical, determines if checkbox variables are labeled as
"Checked" or using the checkbox label.  Only applicable when \code{factors = TRUE}}
}
\description{
Converts a field exported from REDCap into a valid R vector
}
\details{
This function is called internally by \code{rc_export}. It is not
available to the user.
}
\author{
Jeffrey Horner
}
