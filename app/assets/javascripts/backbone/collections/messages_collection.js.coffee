Partnr.Collections.MessagesCollection = Backbone.Collection.extend
  model: Partnr.Models.MessageModel

  url: () ->
    '/messages/'+String(@id)

  initialize: (models, options) ->
    @id = options.id
