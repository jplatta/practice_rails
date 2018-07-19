class GreWords.Views.WordsAdd extends Backbone.View

  template: JST['words/add_word']

  render: ->
    $(@el).html(@template())
    this
