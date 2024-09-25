test_that("Doesn't produce an error", {
  fake.dat <- data.frame(long = seq(from = -50, to = -70, length.out=50),
                         lat=seq(from=30, to =70, length.out=50),
                         means = runif(50, 30, 40))
  expect_no_error(plot_predictions(fake.dat))
})
