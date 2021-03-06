% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rc_logic_check.R
\name{rc_logic_check}
\alias{rc_logic_check}
\title{Check branching logic for errors}
\usage{
rc_logic_check(
  data_dict = getOption("redcap_bundle")$data_dict,
  events = getOption("redcap_bundle")$event_data$unique_event_name
)
}
\arguments{
\item{data_dict}{REDCap project data data_dictionary. By default,
$data_dict is expected in the REDCap bundle option, as created by \code{rc_bundle}.
Otherwise, a data.frame containing the metadata must be supplied.}

\item{events}{Character. Vector of redcap event names}
}
\description{
Check branching logic for common errors
}
\details{
This function will verify that all event and variable names used in the
branching logic exist in the project metadata. It will also warn of faulty logic
concerning \code{[event-name] = 'event_name'} conditions.
}
\author{
Marcus Lehr
}
