test_that("Gets Data, Proper Dates", {
  id <- 3047
  start <- '2006-11-25'
  end <- '2006-12-01'

  dat <- extract_data(id, start, end)
  expected.dat <- daily_data |> filter(WBANNO == id &
                                         daily_data$LST_DATE >= start &
                                         daily_data$LST_DATE <= end)

  # Print actual and expected data frames for comparison
  print("Actual Data:")
  print(dat)
  print("Expected Data:")
  print(expected.dat)

  expect_true(all.equal(dat, expected.dat, check.attributes = FALSE))
})

test_that('Correctly Handles Improper Start Date', {
  start<- '1999-03-12'
  id<-3047

  dat<- extract_data(id,start)
  full.dat <- extract_data(id)

  expect_equal(min(dat$LST_DATE), min(full.dat$LST_DATE))
})

test_that('Correctly Handles Improper End Date', {
  end<- '2078-03-12'
  id<-3047

  dat<- extract_data(id,end=end)
  full.dat <- extract_data(id)

  expect_equal(max(dat$LST_DATE), max(full.dat$LST_DATE))
})
