#' Daily Weather Data from Weather Stations Across the United States
#'
#' This data set contains information of daily climate conditions at 237 Weather
#' Stations across the United States
#'
#' @docType data
#' @usage data(daily_data)
#'
#' @format a dataframe with 1134352 rows and 28 columns
#' \describe{
#' \item{WBANNO}{The station WBAN number.}
#' \item{LST_DATE}{The Local Standard Time (LST) date of the observation.}
#' \item{CRX_VN}{The version number of the station datalogger program that was
#' in effect at the time of the observation.}
#' \item{LONGITUDE}{Station longitude, using WGS-84.}
#' \item{LATITUDE}{Station latitude, using WGS-84.}
#' \item{T_DAILY_MAX}{Maximum air temperature, in degrees C.}
#' \item{T_DAILY_MIN}{Minimum air temperature, in degrees C.}
#' \item{T_DAILY_MEAN}{Mean air temperature, in degrees C, calculated using the
#'  typical historical approach: (T_DAILY_MAX + T_DAILY_MIN) / 2.}
#' \item{T_DAILY_AVG}{Average air temperature, in degrees C.}
#' \item{P_DAILY_CALC}{Total amount of precipitation, in mm.}
#'  \item{SOLARAD_DAILY}{Total solar energy, in MJ/meter^2, calculated from the
#'  hourly average global solar radiation rates and converted to energy by
#'  integrating over time.}
#'  \item{SUR_TEMP_DAILY_TYPE}{Type of infrared surface temperature measurement.}
#'  \item{SUR_TEMP_DAILY_MAX}{Maximum infrared surface temperature, in degrees C.}
#'  \item{SUR_TEMP_DAILY_MIN}{Minimum infrared surface temperature, in degrees C.}
#'  \item{SUR_TEMP_DAILY_AVG}{Average infrared surface temperature, in degrees C.}
#'  \item{RH_DAILY_MAX}{Maximum relative humidity, in \%.}
#'  \item{RH_DAILY_MIN}{Minimum relative humidity, in \%.}
#'  \item{RH_DAILY_AVG}{Average relative humidity, in \%.}
#'  \item{SOIL_MOISTURE_5_DAILY}{Average soil moisture, in fractional volumetric
#'   water content (m^3/m^3), at 5 cm below the surface.}
#'  \item{SOIL_MOISTURE_10_DAILY}{Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 10 cm below the surface.}
#'  \item{SOIL_MOISTURE_20_DAILY}{Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 20 cm below the surface.}
#'  \item{SOIL_MOISTURE_50_DAILY}{Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 50 cm below the surface.}
#'  \item{SOIL_MOISTURE_100_DAILY}{Average soil moisture, in fractional
#'  volumetric water content (m^3/m^3), at 100 cm below the surface.}
#'  \item{SOIL_TEMP_5_DAILY}{Average soil temperature, in degrees C, at 5 cm
#'  below the surface.}
#'  \item{SOIL_TEMP_10_DAILY}{Average soil temperature, in degrees C, at 10 cm
#'  below the surface.}
#'  \item{SOIL_TEMP_20_DAILY}{Average soil temperature, in degrees C, at 20 cm
#'  below the surface.}
#'  \item{SOIL_TEMP_50_DAILY}{Average soil temperature, in degrees C, at 50 cm
#'  below the surface.}
#'  \item{SOIL_TEMP_100_DAILY}{Average soil temperature, in degrees C, at 100 cm
#'  below the surface.}
#' }
"daily_data"

#' Information on U.S. Climate Reference Network Stations
#'
#' This dataset contains location and identification information on all 237
#' stations used to collect daily climate data across America by the USCRN
#' @docType data
#' @usage data(stations)
#'
#' @format a dataframe with 237 rows and 5 columns
#' \describe{
#' \item{Station_Name}{The name of the USCRN Station, usually the City in
#' which it is located}
#' \item{State}{The two letter abbreviation of the State that the station is in}
#' \item{Station_ID}{The station WBAN number}
#' \item{Longitude}{Station longitude, using WGS-84.}
#' \item{Latitude}{Station latitude, using WGS-84}
#' }
"stations"
