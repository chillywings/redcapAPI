#' @name genericApiCall
#' @title Generic Interface the REDCap API.
#'   
#' @description Permits users to make generic calls to the REDCap
#'   API. This allows use of API methods that do not yet have
#'   dedicated support.
#'   
#' @param url A url address to connect to the REDCap API
#' @param token A REDCap API token
#' @param content \code{character(1)} The content argument for the
#'   API call.
#' @param make_data_frame \code{logical(1)}. When \code{TRUE}, an
#'   attempt is made to coerce the output to a data frame with
#'   \code{read.csv}.  Otherwise, it is returned as a character
#'   vector.
#' @param colClasses A named list of column names and
#'   classes to apply via \code{read.csv}
#' @param returnFormat \code{character(1)} The format for the return.
#'   Defaults to \code{"csv"}.
#' @param ... Additional named arguments giving arguments to the
#'   API method. 
#' @param error_handling An option for how to handle errors returned by the API.
#'   see \code{\link{redcap_error}}
#'   
#' @export

genericApiCall <- function(url = getOption("redcap_bundle")$redcap_url,
token = getOption("redcap_token"),
 content,
                                 make_data_frame = TRUE,
                                 colClasses = NA,
                                 returnFormat = "csv",
                                 ...,
                                 error_handling = getOption("redcap_error_handling")){
  coll <- checkmate::makeAssertCollection()
  
  checkmate::assert_character(x = url,
                          add = coll)

  checkmate::assert_character(x = token,
                          add = coll)
  
  checkmate::assert_character(x = content,
                              len = 1,
                              add = coll)
  
  checkmate::assert_logical(x = make_data_frame,
                            len = 1,
                            add = coll)
  
  checkmate::assert_character(x = returnFormat,
                              len = 1,
                              add = coll)
  
  checkmate::reportAssertions(coll)
  
  body <- list(...)
  body[["token"]] <- token
  body[["content"]] <- content
  body[["returnFormat"]] <- returnFormat
  
  x <- httr::POST(url = url, 
                  body = body)
  
  if (x$status_code != 200) return(redcap_error(x, error_handling))
  
  x <- as.character(x)
  
  if (make_data_frame){
    tryCatch(utils::read.csv(text = x,
                             colClasses = NA,
                             stringsAsFactors = FALSE),
             error = function(cond) 
               stop("An error occurred while coercing the result to a data frame: ",
                    cond))
  }
  else
  {
    x
  }
}
