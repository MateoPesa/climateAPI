#' Create a grid of points within the boundaries of the continental United States
#'
#' This function generates a grid of points within the boundaries of the continental United States.
#' The grid is defined by the specified \code{resolution}, which determines the number of points
#' along the latitude and longitude axes.
#'
#' @param resolution The number of points along each axis of the grid.
#' @return A matrix containing the latitude and longitude coordinates of the points within the
#' continental United States.
#' @export
#' @examples
#' # Generate a grid of points with a resolution of 100
#' grid <- america_grid(100)
america_grid <- function(resolution) {
  #Initialize a map
  map <- map('usa', plot = FALSE)

  #Create a grid using minimum and maximum latitude and longitude
  x.points <- seq(map$range[1], map$range[2], length.out = resolution)
  y.points <- seq(map$range[3], map$range[4], length.out = resolution)
  grid <- expand.grid(x.points, y.points)

  #map.where returns NA for points outside of US
  inside <- map.where('usa', grid)

  #ifElse to create a logical vector for plotting indices
  inside.logical <- ifelse(is.na(inside), FALSE, TRUE)

  grid.points <-
    cbind(grid[inside.logical, 1], grid[inside.logical, 2])

  return(grid.points)
}

#' Interpolate Data Using GpGp's Gaussian Process
#'
#' This function performs data interpolation using GpGp.It fits a GPR model to
#' the provided data (\code{dat}), predicts the values at specified locations
#' using the \code{america_grid} function, and returns a dataframe containing
#' the interpolated values along with their corresponding longitude and latitude
#' coordinates.
#'
#' @param response The name of the response variable to be interpolated.
#' @param dat The dataframe containing the data to be used for interpolation.
#' By default, it uses the daily_data dataframe.
#' @param resolution The resolution of the grid used for interpolation.
#' Default is 100.
#' @return A dataframe containing the longitude, latitude, and interpolated
#' values of the response variable.
#' @export
#' @examples
#' # Interpolate temperature data
#' fake.dat <- data.frame(LONGITUDE = runif(35, 30, 40),
#' LATITUDE=runif(35, 30, 40),
#' means = runif(35, 30, 40))
#' interp <- interpolate_data('means', dat= fake.dat,resolution = 150)
interpolate_data <-
  function(response,
           dat = daily_data,
           resolution = 100) {
    #Extract value that we want to predict
    y <- dat[, response]

    #Extract latitude and longitude, removing NA's
    lon <- dat$LONGITUDE
    lon.no.miss <- lon[!is.na(lon)]
    lat <- dat$LATITUDE
    lat.no.miss <- lat[!is.na(lat)]

    #Create a location matrix and a design matrix of 1's, latitude, and longitude
    loc <- cbind(lon.no.miss, lat.no.miss)
    X <- cbind(rep(1, length(lat.no.miss)), loc)

    #Fit the model using GpGp
    gpfit <-
      fit_model(y,
                locs = loc,
                X = X,
                covfun_name = 'matern_sphere',
                silent=TRUE)

    #Use america_grid to get points to interpolate
    prediction.loc <- america_grid(resolution)

    #Design matrix for prediction locations
    X.pred <- cbind(rep(1, nrow(prediction.loc)), prediction.loc)

    #Predictions
    pred <-
      predictions(gpfit, locs_pred = prediction.loc, X_pred = X.pred)

    #Create dataframe with lon/lat and their respective predictions
    pred.df <- as.data.frame(cbind(prediction.loc, pred))
    colnames(pred.df) <- c('lon', 'lat', response)

    return(pred.df)
  }

#' Plot Predictions as Heatmap
#'
#' This function creates a heatmap plot to visualize predicted values over a geographical area.
#'
#' @param df A dataframe containing longitude, latitude, and predicted values.
#' Should be a return value of \code{interpolate_values}
#' @return A ggplot2 object representing the heatmap plot.
#' @export
#' @examples
#' # Create a dataframe
#' fake.dat <- data.frame(LONGITUDE = runif(35, 30, 40),
#' LATITUDE=runif(35, 30, 40),
#' means = runif(35, 30, 40))
#' interp <- interpolate_data('means', dat= fake.dat,resolution = 150)#' # Plot predictions
#' plot <- plot_predictions(interp)
plot_predictions <- function(df) {
  us_map <- map_data("usa")

  # Create a ggplot object for the US map
  ggplot() +
    geom_polygon(data = us_map, aes(x = long, y = lat, group = group), fill = "lightgray") +
    geom_point(data = df, aes(x = df[,1], y = df[,2], colour=df[,3]), size=2) +
    scale_colour_gradient(low = "royalblue3", high = "firebrick1", limits=c(-25,40)) +
    labs(
      x = "Longitude",
      y = "Latitude")
}
