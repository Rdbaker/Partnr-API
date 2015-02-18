Partnr.Views.PortfolioView = Backbone.View.extend
  template: JST["backbone/templates/portfolio/portfolio"]

  initialize: () ->
    @render()

  render: () ->
    @$el.html(@template({projects: []}))
