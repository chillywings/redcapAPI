#' @name rc_cast
#'
#' @title Convert REDCap data to true wide format
#' @description REDCap structures data in a semi-wide format where there
#' are 4 factor variables (record_id and the redcap event/repeat fields)
#' followed by a column for each variable. This function will convert the
#' redcap event and repeat to short hand notation and concatenate them, then
#' append them to any variable names which require distinguishment based on
#' these factors. These and any naturally wide variables will be 'zipped'
#' (coalesced) row-wise so that the resulting data.frame has only a single
#' row per record_id. 
#' 
#' @param record_data Dataframe. Record data exported from REDCap
#' @param events Character. Vector of redcap event names. By default
#' this will be pulled from the data dictionary.
#' @param id_field Character. Column name of the record_id field.
#' 
#' @importFrom magrittr '%>%'
#' 
#' @author Marcus Lehr
#' 


rc_cast <- function(record_data,
                    events = getOption("redcap_bundle")$event_data$unique_event_name,
                    id_field = getOption("redcap_bundle")$id_field) {
  
  validate_args(required = c('record_data'),
                record_data = record_data,
                events = events,
                id_field = id_field)
  
  id_field = getID(record_data = record_data,
                   id_field = id_field)
  
  rc_factors = intersect(c(id_field,'redcap_event_name','redcap_repeat_instrument','redcap_repeat_instance'),
                        names(record_data))
  
  # # Remove arm designation if only 1 arm is in use
  # record_data$redcap_event_name = as.factor(record_data$redcap_event_name)
  # if (!all(grepl('arm_2$',levels(record_data$redcap_event_name)))) 
  #   levels(record_data$redcap_event_name) = gsub('_arm_1$','',levels(record_data$redcap_event_name))
  
  # Convert events to factors while preserving order
  record_data$redcap_event_name = factor(record_data$redcap_event_name, levels = events)
  
  # Remove first repeats for more compact output
  first_reps = which(record_data$redcap_repeat_instance == 1)
  record_data$redcap_repeat_instrument[first_reps] = NA
  record_data$redcap_repeat_instance[first_reps] = NA
  
  # Determine which vars are long format
  agg_vars = reshape2::melt(dplyr::select(record_data, -contains('redcap_')), id.vars = id_field, na.rm = T)
  cast_formula = paste0(id_field, '~variable')
  agg_vars = reshape2::dcast(agg_vars, cast_formula, length)
  agg_vars = dplyr::filter_at(agg_vars, names(agg_vars)[2:length(names(agg_vars))], dplyr::any_vars(.>1)) %>% 
                              dplyr::select_if(dplyr::vars(max(.)>1))
  
  # Melt/spread long vars
  lvars = dplyr::select(record_data, all_of(rc_factors), all_of(names(agg_vars)))
  lvars = dplyr::mutate_all(lvars, as.character) # This is to prevent melt() from destroying dates
  # lvars = dplyr::ungroup(lvars) %>% dplyr::filter(rowSums(!is.na(lvars)) > 2) # Remove empty rows
  lvars = reshape2::melt(lvars, id.vars = c(id_field,'redcap_event_name'), na.rm = T)
  lvars$variable = paste(lvars$redcap_event_name, lvars$variable, sep = '_')
  lvars = dcast(lvars, hnrcid~variable)
  
  
  # Coalesce wide vars into single row/subject
  wvars = select(data, 1, all_of(setdiff(names(data),names(agg_vars))), 
                 -contains('bp'), -redcap_event_name)
  wvars = mutate_all(wvars, as.character)
  # wvars = wvars %>% group_by(hnrcid) %>% summarise_all(~coalesce(!!!as.list(.)))
  wvars[is.na(wvars)] = ''
  wvars = wvars %>% group_by(hnrcid) %>% summarise_all(~trimws(paste(.,collapse = '')))
  wvars = sapply(wvars, function(x) ifelse(x=='',NA,x)) %>% as.data.frame()
  wvars$hnrcid = wvars$hnrcid %>% as.character() %>% as.numeric()
  
  
  # Rejoin data
  data = left_join(wvars, lvars)
}