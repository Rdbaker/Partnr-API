$(document).ready ->
  logging_in = false
  signing_up = false

  # hide both forms
  $('#signup-form').hide()
  $('#login-form').hide()

  # login button handler
  $("#login-btn").on('click', ->
    # submit the form
    if logging_in
      submitForm()
    # or change the form
    else
      logging_in = true
      signing_up = false
      $('#signup-form').slideUp()
      $('#login-form').slideDown()
  )

  # signup button handler
  $("#signup-btn").on('click', ->
    # submit the form
    if signing_up
      submitForm()
    # or change the form
    else
      logging_in = false
      signing_up = true
      $('#login-form').slideUp()
      $('#signup-form').slideDown()
  )

  # submit the form on pressing enter
  $('input').on('keypress', (e) ->
    if e.which == 13
      submitForm()
  )

  # submit the form to the proper route
  submitForm = () ->
    if logging_in
      $("#login-form").submit()
    else if signing_up
      $("#signup-form").submit()
