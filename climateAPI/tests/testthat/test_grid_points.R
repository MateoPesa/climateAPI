test_that("All points fall within American lines" , {
  griddy <- america_grid(100)
  usmap <- map('usa', plot=FALSE)
  wheres <- map.where('usa', griddy)

  expect_false(all(sapply(wheres, is.na)))
})

test_that('Dataframe has 2 columns', {
  griddy <- america_grid(10)
  expect_true(ncol(griddy)==2)
})

test_that("Handles 0 correctly (Empty Dataframe)", {
  griddy <- america_grid(0)
  expect_true(nrow(griddy) == 0)
})
