Partnr.Views.MessageView = Backbone.View.extend
  template: JST["backbone/templates/inbox/message"]

  collection: undefined

  initialize: () ->
    @render()

  render: () ->
    # if the collection exists, remove it
    if !!@collection
      @collection.id = @id
    else
      # create a new collection for the message
      @collection = new Partnr.Collections.MessagesCollection([], {id: @id})

    # listen to collection addition
    @listenTo this.collection, 'add', @renderMessages

    @collection.fetch(
      success: (collection) ->
        collection.trigger 'add'
    )

  renderMessages: () ->
    @$el.html @template messages: @collection

    # when they press enter trigger the 'enter' event
    $('#send-message-content').keyup (event) ->
      if event.keyCode == 13
        $(@).trigger 'enter'

  # change the id of the view so the
  # collection changes
  changeId: (id) ->
    @id = id
    @render()

  replyToMessage: () ->
    message = new Partnr.Models.MessageModel({
      message: @messageBody(),
      sender: window.user.name
      conv_id: @id
    })
    @collection.push message
    message.save()

  messageId: () ->
    Number($("tr.active.warning").attr('data-id'))

  messageBody: () ->
    $('#send-message-content', @$el).val()

  # overload function so it doesn't destroy
  # it's parent's DOM
  remove: () ->
    @collection.remove()
    $(@el.children).remove()
    @stopListening()
    @

  events:
    "enter #send-message-content"  : "replyToMessage"
    "click #send-message-btn"      : "replyToMessage"
