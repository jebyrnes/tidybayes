# gather_draws
#
# Author: mjskay
###############################################################################


# deprecated names for gather_draws --------------------------------------

#' @rdname tidybayes-deprecated
#' @format NULL
#' @usage NULL
#' @export
gather_samples = function(...) {
  .Deprecated("gather_draws", package = "tidybayes") # nocov
  to_broom_names(gather_draws(...))  # nocov
}



# gather_draws ------------------------------------------------------------

#' @rdname spread_draws
#' @importFrom dplyr bind_rows group_by_at
#' @importFrom rlang enquos
#' @export
gather_draws = function(model, ..., regex = FALSE, sep = "[, ]") {
  tidysamples = lapply(enquos(...), function(variable_spec) {
    model %>%
      spread_draws_(variable_spec, regex = regex, sep = sep) %>%
      gather_variables()
  })

  #get the groups from all the samples --- when we bind them together,
  #the grouping information is not always retained, so we'll have to recreate
  #the full set of groups from all the data frames after we bind them
  groups_ = tidysamples %>%
    map(group_vars) %>%
    reduce(union)

  bind_rows(tidysamples) %>%
    group_by_at(groups_)
}
