class GreWords.Routers.Words extends Backbone.Router

  routes:
    '': 'index'

  initialize: ->
    @words = new GreWords.Collections.Words()
    #@words.comparator = 'word'
    @words.fetch({reset: true})
    #@collection.reset($('#container').data('words'))

  index: ->
    view = new GreWords.Views.WordsIndex(collection: @words)
    $('#container').html(view.render().el)
