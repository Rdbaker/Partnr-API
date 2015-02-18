Partnr.Models.MessageModel = Backbone.Model.extend
  # override the default behavior because
  # it'll never send POST requests since it's not
  # treated like a typical rails resource
  save: () ->
    if @validate
      throw 'Error: Required fields not present for a message'
    else
      $.ajax
        type: 'PUT'
        url: "/messages/#{@.get('conv_id')}"
        data:
          message: @.get 'message'
          id: @.get 'conv_id'

  validate: (attrs, options) ->
    !!attrs['conv_id'] && !!atrs['message']
