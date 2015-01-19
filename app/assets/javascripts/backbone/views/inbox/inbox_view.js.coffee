Partnr.Views.InboxView = Backbone.View.extend
  messages_template: JST["backbone/templates/inbox/messages_table"]

  parent_view_object: $ JST["backbone/templates/inbox/inbox"]()
  new_message_object: $ JST["backbone/templates/inbox/send_message"]()

  # if the conversation view is open
  dialog: false

  initialize: () ->
    $.get('/messages', (data) =>
      console.log data
      @render()
      @renderTable data
    )

  # render the messages view
  render: () ->
    if !!@dialog
      @dialog.remove()
    # create the message rows
    @$el.html @parent_view_object

  # render the messages table
  renderTable: (messages) ->
    $('#messages-table').html @messages_template messages: messages

    #highlight the proper message row
    $('tr', $ '#messages-table' ).click () ->
      $('.warning', $ '#messages-table' ).removeClass 'warning'
      $(@).addClass 'warning'

  # open the new message form
  openMessage: (event) ->
    event.currentTarget.parentElement.insertBefore @new_message_object[0], event.currentTarget.nextElementSibling

  # close the new message form
  closeMessage: (event) ->
    # triggered from the 'cancel' button click
    if !!event
      event.currentTarget.parentElement.remove()
    else
      $('#send-message-form').remove()

  # validate the message
  goodMessage: () ->
    message_cont = $("#message-content").val()
    message_email = $("#recipientEmail").val()
    # for now, just check if it's there
    return !!message_cont && !!message_email

  # send the new message
  sendMessage: (event) ->
    if @goodMessage()
      $.post '/messages',
        {
          'email' : $("#recipientEmail").val(),
          'message' : $("#message-content").val()
        },
        (data) ->
          # not really sure what it would return/do here
          console.log data
      @closeMessage()
    else
      #do nothing
      #let the user know what went wrong
      console.log 'bad message'

  # open a message's conversation
  openDialog: (event) ->
    message_id = event.currentTarget.attributes['data-id'].value
    # make sure message_id exists
    if !!message_id
      # if there is a dialog
      if !!@dialog
        # change the conversation id
        @dialog.changeId(message_id)
      else
        # make a new dialog
        @dialog = new Partnr.Views.MessageView({el: $("#message-wrapper"), id: message_id})

  replyToMessage: (event) ->
    if !!event && event.type == "enter"
      message = event.currentTarget.value
    else
      message = $('#send-message-content').val()
    message_id = $('tr.warning').attr('data-id')
    $.ajax(
      url: '/messages/'+message_id
      type: 'PUT'
      data: { message: message }
      success: (data) ->
        console.log data
    )

  events:
    "click #new-message-btn"         : "openMessage",
    "click #cancel-new-message-btn"  : "closeMessage",
    "click #send-new-message-btn"    : "sendMessage",
    "click #messages-table tr"       : "openDialog",
