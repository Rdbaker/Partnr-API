$ ->
  logging_in = false
  signing_up = false

  $('#signup-form').hide()
  $('#login-form').hide()

  $("#login-btn").on('click', ->
    if logging_in
      console.log "send req to server"
    else
      logging_in = true
      signing_up = false
      $('#signup-form').slideUp()
      $('#login-form').slideDown()
  )

  $("#signup-btn").on('click', ->
    if signing_up
      console.log "send req to server"
    else
      logging_in = false
      signing_up = true
      $('#login-form').slideUp()
      $('#signup-form').slideDown()
  )
