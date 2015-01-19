Partnr.Routers.Router = Backbone.Router.extend
  routes:
    ""           :  "home"
    "settings"   :  "settings"
    "portfolio"  :  "portfolio"
    "inbox"      :  "inbox"
    "partners"   :  "partners"

  views: {}

  navbar: $("#navbar")

  home: () ->
    if !@views.home
      @views.home = new Partnr.Views.HomeView({el: $("#view-injection")})
    else
      @views.home.render()
    $(".btn-info").removeClass("btn-info")
    $("#user-home-link").addClass("btn-info")

  partners: () ->
    if !@views.partners
      @views.partners = new Partnr.Views.PartnersView({el: $("#view-injection")})
    else
      @views.partners.render()
    $(".btn-info").removeClass("btn-info")
    $("#user-partners-link").addClass("btn-info")

  settings: () ->
    if !@views.settings
      @views.settings = new Partnr.Views.SettingsView({el: $("#view-injection")})
    else
      @views.settings.render()
    $(".btn-info").removeClass("btn-info")
    $("#user-settings-link").addClass("btn-info")

  inbox: () ->
    if !@views.inbox
      @views.inbox = new Partnr.Views.InboxView({el: $("#view-injection")})
    else
      @views.inbox.initialize()
    $(".btn-info").removeClass("btn-info")
    $("#user-inbox-link").addClass("btn-info")

  portfolio: () ->
    if !@views.portfolio
      @views.portfolio = new Partnr.Views.PortfolioView({el: $("#view-injection")})
    else
      @views.portfolio.render()
    $(".btn-info").removeClass("btn-info")
    $("#user-portfolio-link").addClass("btn-info")
