#' Finds the expected yearly change in average temperature in degrees celsius
#' for a given station.
#'
#' Fits a linear model of average temperatures of USCRN stations to years
#' and returns its beta coefficient.
#'
#' @param id A unique numeric WBANNO id of the station to fit the model for
#'
#'@examples
#'  #Get expected temperature change for station number 3047 (Monahans 6 TX)
#'  temp_trends(3047)
#'@export
temp_trends <- function(id) {
  #Handle id non-existent
if (!(id %in% daily_data$WBANNO)) {
    closest <- daily_data$WBANNO[which.min(abs(daily_data$WBANNO - id))]
    cat(id, "is not a valid Station ID, assigning to closest Station", closest, '\n')
    id <- closest
  }
  #Extract data for the station
  station_data <- extract_data(id)

  #Get earliest and latest year
  earliest_year <- min(station_data$LST_DATE)
  latest_year <- max(station_data$LST_DATE)

  #Create a sequence of years
  years <- seq(from = earliest_year, to = latest_year, by = "year")

  #Initialize a dataframe to store results
  mean_temperatures <- data.frame(
    Day = numeric(0),
    Predicted_Temp = numeric(0),
    year = integer(0),
    month = integer(0)
  )

  #Calculate mean temperatures for each year
  for (i in 1:(length(years) - 1)) {
    year_start <- years[i]
    year_end <- years[i + 1]

    #Extract data for the current year
    year_data <- yearly_cycle_one_year(id, start = year_start, end = year_end)

    #Get year and month
    year_data$year <- i
    year_data$month <- format(strptime(year_data$Day, '%j'), '%m')

    #Append to mean_temperatures
    mean_temperatures <- rbind(mean_temperatures, year_data)
  }

  #Convert 'month' to factors
  mean_temperatures$month <- as.factor(mean_temperatures$month)

  #Fit a linear model
  lm.fit <- lm(Predicted_Temp ~ year + month, data = mean_temperatures)

  #Get the coefficients and p-values
  coef <- coef(lm.fit)
  p_values <- summary(lm.fit)$coefficients[2, 4]

  #Create a named vector for results
  ret_vec <- c(id, coef[1], coef[2], p_values)
  names(ret_vec) <- c("Station_ID", "Intercept", "Slope", "PValue")

  return(ret_vec)
}

