context("test-option")

test_that("program exists", {
  if(is_windows() || is_macos()){
    expect_true(file.exists(ssh_askpass()))
  }
})

test_that("option askpass is respected", {
  options(askpass = function(...){
    'supersecret'
  })
  expect_equal(askpass(), 'supersecret')
})
