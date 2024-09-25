
test_that("Column one is 1:365", {
  cycle <- yearly_cycle(3047)
  expect_equal(cycle$Day, c(1:365))
}
)

test_that("Dataframe is numeric", {
  cycle <- yearly_cycle(3047)
  expect_true(all(sapply(cycle, is.numeric)))
})

test_that("yearly_cycle and yearly_cycle_one_year produce same results given same day", {
  y_cycle <- yearly_cycle(3047)

  #Don't need to feed in start end dates of min and max dates of 3047 due to default values
  y_cycle_one <- yearly_cycle_one_year(3047)

  expect_equal(y_cycle, y_cycle_one)
})

