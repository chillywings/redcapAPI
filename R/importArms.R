#' @name importArms
#' @title Import Study Arm Names
#' 
#' @description Import Arms into a project or to rename existing Arms in a 
#'   project. You may use the parameter \code{override = TRUE} as a 'delete 
#'   all + import' action in order to erase all existing Arms in the 
#'   project while importing new Arms. Notice: Because of the 'override' 
#'   parameter's destructive nature, this method may only use 
#'   \code{override = TRUE} for projects in Development status.
#'   
#' @param url A url address to connect to the REDCap API
#' @param token A REDCap API token
#' @param arms_data A \code{data.frame} with two columns.  The first column 
#'   is an integer-like value with the name \code{arm_num}. The second is
#'   a character value with the name \code{name}.
#' @param override \code{logical(1)}. When \code{TRUE}, the action is to 
#'   delete all of the arms in the project and import the contents of 
#'   \code{arms_data}.  The default setting is \code{FALSE}, which only
#'   allows arms to be renamed or added.
#' @param error_handling An option for how to handle errors returned by the API.
#'   see \code{\link{redcap_error}}
#' @param ... additional arguments to pass to other methods.
#' 
#' @details REDCap API Documentation:
#' This method allows you to import Arms into a project or to rename 
#' existing Arms in a project. You may use the parameter override=1 as a 
#' 'delete all + import' action in order to erase all existing Arms in the 
#' project while importing new Arms. Notice: Because of the 'override' 
#' parameter's destructive nature, this method may only use override=1 
#' for projects in Development status.
#' 
#' NOTE: This only works for longitudinal projects.
#' 
#' REDCap Version:
#' At least 8.1.17+ (and likely some earlier versions)
#' 
#' @return 
#' No value is returned.
#' 
#' @references
#' Please refer to your institution's API documentation.
#' 
#' @export

importArms <- function(url = getOption("redcap_bundle")$redcap_url,
token = getOption("redcap_token"),
 arms_data, 
                             override = FALSE, ...,
                             error_handling = getOption("redcap_error_handling")){
  coll <- checkmate::makeAssertCollection()
  
  checkmate::assert_data_frame(x = arms_data,
                               ncols = 2,
                               add = coll)
  
  checkmate::assert_logical(x = override,
                            len = 1,
                            add = coll)
  
  checkmate::reportAssertions(coll)
  
  checkmate::assert_subset(x = names(arms_data),
                           choices = c("arm_num", "name"),
                           add = coll)
  
  checkmate::reportAssertions(coll)
  
  checkmate::assert_integerish(arms_data[["arm_num"]],
                               add = coll,
                               .var.name = "arms_data$arm_num")
  
  checkmate::assert_character(arms_data[["name"]],
                              add = coll,
                              .var.name = "arms_data$name")
  
  checkmate::reportAssertions(coll)
  
  arms_data <- 
    utils::capture.output(
      utils::write.csv(arms_data,
                       file = "",
                       na = "",
                       row.names = FALSE)
    )
  arms_data <- paste0(arms_data, collapse = "\n")
      
      
  body <- list(token = token,
               content = "arm",
               override = as.numeric(override),
               action = "import",
               format = "csv",
               data = arms_data)
  
  x <- httr::POST(url = url, 
                  body = body)
  
  if (x$status_code != 200) return(redcap_error(x, error_handling))
}