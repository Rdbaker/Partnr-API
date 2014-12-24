Partnr.Views.HomeView = Backbone.View.extend
  initialize: () ->
    @render()

  render: () ->
    @$el.html("this is the home view")
