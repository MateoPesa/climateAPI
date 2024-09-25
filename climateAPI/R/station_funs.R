#' Retrieve weather data for a given station id
#'
#' Retrieves the daily climate data from USCRN stations given a station id and
#' optionally a starting and ending date.
#'
#' @param id A unique numeric WBANNO id of the station to retrieve
#' @param start Character string in "&Y-%m-%d format representing the starting date
#' of the data to retrieve. Earliest possible date by default.
#' @param end Character string in "&Y-%m-%d format representing the
#'  ending date of the data to retrieve. Latest possible date by default
#' @return A dataframe with the following components:
#' \itemize{
#' \item{WBANNO} : {The station WBAN number.}
#'\item{LST_DATE} : {The Local Standard Time (LST) date of the observation.}
#'\item{CRX_VN} : {The version number of the station datalogger program that was
#'  in effect at the time of the observation.}
#'\item{LONGITUDE} : {Station longitude, using WGS-84.}
#'\item{LATITUDE} : {Station latitude, using WGS-84.}
#'\item{T_DAILY_MAX} : {Maximum air temperature, in degrees C.}
#'\item{T_DAILY_MIN} : {Minimum air temperature, in degrees C.}
#'\item{T_DAILY_MEAN} : {Mean air temperature, in degrees C, calculated using the
#'  typical historical approach: (T_DAILY_MAX + T_DAILY_MIN) / 2.}
#'\item{T_DAILY_AVG} : {Average air temperature, in degrees C.}
#'\item{P_DAILY_CALC} : {Total amount of precipitation, in mm.}
#'\item{SOLARAD_DAILY} : {Total solar energy, in MJ/meter^2, calculated from the
#'  hourly average global solar radiation rates and converted to energy by
#'  integrating over time.}
#'\item{SUR_TEMP_DAILY_TYPE} : {Type of infrared surface temperature measurement.}
#'\item{SUR_TEMP_DAILY_MAX} : {Maximum infrared surface temperature, in degrees C.}
#'\item{SUR_TEMP_DAILY_MIN} : {Minimum infrared surface temperature, in degrees C.}
#'\item{SUR_TEMP_DAILY_AVG} : {Average infrared surface temperature, in degrees C.}
#'\item{RH_DAILY_MAX} : {Maximum relative humidity, in \%.}
#'\item{RH_DAILY_MIN} : {Minimum relative humidity, in \%.}
#'\item{RH_DAILY_AVG} : {Average relative humidity, in \%.}
#'\item{SOIL_MOISTURE_5_DAILY} : {Average soil moisture, in fractional volumetric
#'  water content (m^3/m^3), at 5 cm below the surface.}
#'\item{SOIL_MOISTURE_10_DAILY} : {Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 10 cm below the surface.}
#'\item{SOIL_MOISTURE_20_DAILY} : {Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 20 cm below the surface.}
#'\item{SOIL_MOISTURE_50_DAILY} : {Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 50 cm below the surface.}
#'\item{SOIL_MOISTURE_100_DAILY} : {Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 100 cm below the surface.}
#'\item{SOIL_TEMP_5_DAILY} : {Average soil temperature, in degrees C, at 5 cm
#'  below the surface.}
#'\item{SOIL_TEMP_10_DAILY} : {Average soil temperature, in degrees C, at 10 cm
#'  below the surface.}
#'\item{SOIL_TEMP_20_DAILY} : {Average soil temperature, in degrees C, at 20 cm
#'  below the surface.}
#'\item{SOIL_TEMP_50_DAILY} : {Average soil temperature, in degrees C, at 50 cm
#'  below the surface.}
#'\item{SOIL_TEMP_100_DAILY} : {Average soil temperature, in degrees C, at 100 cm
#'  below the surface.}
#'  }
#'
#'@examples
#'  #Get weather data for station number 3047 (Monahans 6 TX)
#'  mon.dat<-extract_data(3047, start='2003-05-21', end='2003-05-27')
#'  mon.dat[,1:5]
#'
#'@export
extract_data <- function(id,
                         start = min(daily_data[daily_data$WBANNO == id, "LST_DATE"]),
                         end = max(daily_data[daily_data$WBANNO == id, "LST_DATE"])) {
  #Handle ID not valid
  if (!(id %in% daily_data$WBANNO)) {
    closest <- daily_data$WBANNO[which.min(abs(daily_data$WBANNO - id))]
    cat(id,
        "is not a valid Station ID, assigning to closest Station",
        closest,
        '\n')
    id <- closest
  }
  # Check that start date isn't earlier than the minimum date
  if (start < min(daily_data[daily_data$WBANNO == id, "LST_DATE"])) {
    print("Start Date Predates Earliest Records, Using Earliest Recorded Date")
    # Set start to the earliest possible date
    start <- min(daily_data[daily_data$WBANNO == id, "LST_DATE"])
  }

  # Check that end date isn't later than the latest date
  if (end > max(daily_data[daily_data$WBANNO == id, "LST_DATE"])) {
    print("End Date Passes Latest Records, Using Latest Recorded Date")
    # Set end to the latest possible date
    end <- max(daily_data[daily_data$WBANNO == id, "LST_DATE"])
  }

  # Use dplyr to filter by id and date
  station.data <- daily_data %>%
    filter(WBANNO == id & LST_DATE >= start & LST_DATE <= end)

  return(station.data)
}

#' A function for estimating the yearly cycle for one station.
#'
#' Retrieves the yearly cycle for a given station id, where a yearly cycle is
#' the expected temperature on each day of the year.
#'
#' @param id A unique numeric WBANNO station ID of the station to retrieve
#' @return A 365x2 dataframe with the following format:
#' \itemize{
#' \item{Day} : {Numbered day of the year (1-365)}
#' \item{Exp_Temp} : {Expected Temperature for the corresponding day}
#' }
#'
#'@examples
#'  #Get yearly cycle data for station 3047, Monohans 6 in TX
#'  mon6.cycle <-yearly_cycle(3047)
#'  head(mon6.cycle)
#'
#'@export
yearly_cycle <- function(id) {
  #Handle ID not valid
  if (!(id %in% daily_data$WBANNO)) {
    closest <- daily_data$WBANNO[which.min(abs(daily_data$WBANNO - id))]
    cat(id,
        "is not a valid Station ID, assigning to closest Station",
        closest,
        '\n')
    id <- closest
  }
  #Get Station Data
  station.dat <- extract_data(id)

  #Leave Year out of Date to utilize Group_By
  station.dat$LST_DATE <- format(station.dat$LST_DATE, "%m-%d")

  #Group By date and summarize mean
  mean.temps <- station.dat |> filter(LST_DATE != '02-29') |>
    group_by(LST_DATE) |>
    summarize(Exp_Temp = mean(T_DAILY_AVG, na.rm=TRUE))

  #Change date column to numbers
  mean.temps$LST_DATE <- c(1:365)

  #Correct Column Names
  colnames(mean.temps) <- c("Day", "Exp_Temp")

  #Fit a model to these means

  # Create cosine terms for seasonal pattern
  mean.temps$cos1 <- cos(2 * pi * mean.temps$Day / 365)
  mean.temps$sin1 <- sin(2 * pi * mean.temps$Day / 365)

  # Fit linear model
  model <- lm(Exp_Temp ~ cos1 + sin1, data = mean.temps)

  # Predict temperatures using the fitted model
  mean.temps$Predicted_Temp <- predict(model)

  return.frame <- data.frame(Day = mean.temps$Day,
                             Predicted_Temp = mean.temps$Predicted_Temp)

  return(return.frame)
}

#' A hidden function for estimating the yearly cycle for one station given a
#' starting and ending date to calculate means from.
#'
#' Retrieves the yearly cycle for a given station and returns a dataframe of
#' the expected temperatures found using a cyclical linear model fitted to the
#' historical mean temperatures. Used in other functions so is not available
#' for public users
#'
#' @param id A unique numeric WBANNO station ID of the station to retrieve
#' @param start First date you would like to calculate mean using
#' @param end Latest date you would like to use to calculate the mean
#' @return A 365x2 dataframe with the following format:
#' \itemize{
#' \item{Day} : {Numbered day of the year (1-365)}
#' \item{Exp_Temp} : {Expected Temperature for the corresponding day}
#' }
yearly_cycle_one_year <-
  function(id,
           start = min(daily_data[daily_data$WBANNO == id, "LST_DATE"]),
           end = max(daily_data[daily_data$WBANNO == id, "LST_DATE"])) {

    if (!(id %in% daily_data$WBANNO)) {
      closest <- daily_data$WBANNO[which.min(abs(daily_data$WBANNO - id))]
      cat(id,
          "is not a valid Station ID, assigning to closest Station",
          closest,
          '\n')
      id <- closest
    }
    #Get Station Data
    station.dat <- extract_data(id, start, end)

    #Leave Year out of Date to utilize Group_By
    station.dat$LST_DATE <- format(station.dat$LST_DATE, "%m-%d")

    #Group By date and summarize mean
    mean.temps <- station.dat |> filter(LST_DATE != '02-29') |>
      group_by(LST_DATE) |>
      summarize(Exp_Temp = mean(T_DAILY_AVG, na.rm = TRUE))

    #Change date column to numbers
    mean.temps$LST_DATE <- c(1:365)

    #Correct Column Names
    colnames(mean.temps) <- c("Day", "Exp_Temp")

    #Fit a model to these means

    # Create cosine terms for seasonal pattern
    mean.temps$cos1 <- cos(2 * pi * mean.temps$Day / 365)
    mean.temps$cos2 <- sin(2 * pi * mean.temps$Day / 365)

    # Fit linear model
    model <- lm(Exp_Temp ~ cos1 + cos2, data = mean.temps)

    # Predict temperatures using the fitted model
    predictions <- predict(model, mean.temps, na.action = na.pass)
    mean.temps$Predicted_Temp <- predictions

    return.frame <- data.frame(Day = mean.temps$Day,
                               Predicted_Temp = mean.temps$Predicted_Temp)

    return(return.frame)
  }
