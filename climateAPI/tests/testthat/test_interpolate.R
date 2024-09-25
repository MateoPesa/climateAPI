#Interpolated length is the same as number of points from resolution and Numeric
test_that("Interpolate Result is same length as a Grid Result and Numeric", {
   fake.dat <- data.frame(LONGITUDE = runif(35, 30, 40),
                                    LATITUDE=runif(35, 30, 40),
                                    means = runif(35, 30, 40))
   interp <- interpolate_data('means', dat= fake.dat,resolution = 150)
  expect_true(nrow(interp)==nrow(america_grid(150)) & all(sapply(interp, is.numeric)))
})
