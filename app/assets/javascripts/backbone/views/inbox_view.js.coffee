Partnr.Views.InboxView = Backbone.View.extend
  parent_template: JST["backbone/templates/inbox/inbox"]

  new_message_object: $ JST["backbone/templates/inbox/send_message"]()

  initialize: () ->
    @render()

  render: () ->
    @$el.html @parent_template

  openMessage: (event) ->
    event.currentTarget.parentElement.insertBefore @new_message_object[0], event.currentTarget.nextElementSibling

  closeMessage: (event) ->
    event.currentTarget.parentElement.remove()

  sendMessage: (event) ->
    if @goodMessage()
      #send it
      @closeMessage()
    else
      #do nothing
      #let the user know what went wrong

  events:
    "click #new-message-btn"         : "openMessage",
    "click #cancel-new-message-btn"  : "closeMessage",
    "click #send-new-message-btn"    : "sendMessage"
