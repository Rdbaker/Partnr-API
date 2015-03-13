Partnr.Models.MessageModel = Backbone.Model.extend
  # override the default behavior because
  # it'll never send POST requests since it's not
  # treated like a typical rails resource
  save: () ->
    if !@validate()
      throw ValidationError('Message does not have required attributes')
    else
      $.ajax
        type: 'PUT'
        url: "/messages/#{@.get('conv_id')}"
        data:
          message: @.get 'message'
          id: @.get 'conv_id'

  validate: (attrs, options) ->
    !!@get('conv_id') && !!@get('message')
