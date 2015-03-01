#= require backbone
#= require backbone/partnr
#= require_tree ./errors

logout = () ->
  $('#logout-form').submit()

$ ->
  # register the nav click listeners
  $('#user-logout-link').on('click', logout)

  # create the router
  window.router = new Partnr.Routers.Router()

  # start the backbone history
  Backbone.history.start({pushstate: true})

  # use '/' routes instead of '#' in <a> tags
  $(document).on 'click', 'a:not([data-bypass])', (evt) ->
    href = $(this).attr('href')
    protocol = this.protocol + '//'

    if href.slice(protocol.length) != protocol
      evt.preventDefault()
      window.router.navigate(href, true)
