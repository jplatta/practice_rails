class GreWords.Collections.Words extends Backbone.Collection
  url: '/api/words'
  model: GreWords.Models.Word

  shuffleWords: ->
    @shuffle()
