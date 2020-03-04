% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rc_format.R
\name{rc_format}
\alias{rc_format}
\title{Format records data}
\usage{
rc_format(
  record_data,
  data_dict = getOption("redcap_bundle")$data_dict,
  factors = TRUE,
  labels = TRUE,
  dates = TRUE,
  checkboxLabels = FALSE
)
}
\arguments{
\item{record_data}{Dataframe. Record data export from REDCap}

\item{data_dict}{Dataframe. REDCap project data data_dictionary. By default, a
REDCap bundle option, as created by \code{rc_setup}, will be looked for.
Otherwise, a data.frame containing the metadata must be supplied.}

\item{factors}{Logical.  Determines if categorical data from the database is
returned as numeric codes or labelled factors. See 'Checkbox Variables'
for more on how this interacts with the \code{checkboxLabels} argument.}

\item{labels}{Logical.  Determines if the variable labels are applied to
the data frame.}

\item{dates}{Logical. Determines if date variables are converted to POSIXct
format during the download.}

\item{checkboxLabels}{Logical. Determines the format of labels in checkbox
variables.  If \code{FALSE} labels are applies as "Unchecked"/"Checked".
If \code{TRUE}, they are applied as ""/"\link{field_label}" where \link{field_label}
is the label assigned to the level in the data data_dictionary.
This option is only available after REDCap version 6.0.  See Checkbox Variables
for more on how this interacts with the \code{factors} argument.}

\item{completionField}{The REDCap variable which indicates whether or not a subject
has completed the study. This should be indicated by a 'Yes' or a '1' (i.e. a Yes/No
field in REDCap).}
}
\description{
Uses REDCap project metadata to format records data.
}
\details{
This function takes raw REDCap data and adds column labels, converts
columns to numeric/character/factor as appropriate, and applies factor and
checkbox labels.
}
\section{Checkbox Variables}{


There are four ways the data from checkbox variables may be
represented depending on the values of \code{factors} and
\code{checkboxLabels}. The most common are the first and third
rows of the table below.  When \code{checkboxLabels = TRUE}, either
the coded value or the labelled value is returned if the box is
checked, or an empty string if it is not.

\tabular{lll}{
\code{factors} \tab \code{checkboxLabels} \tab Output \cr
\code{FALSE}   \tab \code{FALSE}          \tab 0 / 1 \cr
\code{FALSE}   \tab \code{TRUE}           \tab "" / value \cr
\code{TRUE}    \tab \code{FALSE}          \tab Unchecked / Checked \cr
\code{TRUE}    \tab \code{TRUE}           \tab "" / label
}
}

\author{
Benjamin Nutter

Marcus Lehr
}