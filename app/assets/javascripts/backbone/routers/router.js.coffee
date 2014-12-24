Partnr.Routers.Router = Backbone.Router.extend
  routes:
    ""           :  "home"
    "settings"   :  "settings"
    "portfolio"  :  "portfolio"
    "inbox"      :  "inbox"
    "partners"   :  "partners"

  home: () ->
    new Partnr.Views.HomeView({el: $("#view-injection")})

  partners: () ->
    new Partnr.Views.PartnersView({el: $("#view-injection")})

  settings: () ->
    new Partnr.Views.SettingsView({el: $("#view-injection")})

  inbox: () ->
    new Partnr.Views.InboxView({el: $("#view-injection")})

  portfolio: () ->
    new Partnr.Views.PortfolioView({el: $("#view-injection")})
