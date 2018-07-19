window.GreWords =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new GreWords.Routers.Words()
    Backbone.history.start({pushState: true})

$(document).ready ->
  GreWords.initialize()
