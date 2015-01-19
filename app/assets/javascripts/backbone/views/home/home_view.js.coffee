Partnr.Views.HomeView = Backbone.View.extend
  template: JST["backbone/templates/home/home"]

  initialize: () ->
    @render()

  render: () ->
    @$el.html(@template())
