class GreWords.Views.Word extends Backbone.View

  template: JST['words/word']
  tagName: 'div'

  render: ->
    $(@el).html(@template(word: @model))
    this
