#' @importFrom maps map.where
#' @importFrom ggplot2 map_data
#' @importFrom GpGp predictions
#' @importFrom GpGp fit_model
#' @importFrom dplyr summarize
#' @importFrom dplyr filter
#' @import ggplot2
#' @importFrom stats lm na.pass predict
#' @importFrom stats na.pass
#' @importFrom stats predict
#' @importFrom dplyr %>%
#' @importFrom dplyr group_by
#' @importFrom maps map

mean2 <- function(x) {
  return(sum(x)/length(x))
}
