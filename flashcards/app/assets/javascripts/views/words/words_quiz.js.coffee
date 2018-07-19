class GreWords.Views.WordsQuiz extends Backbone.View

  template: JST['words/quiz']

  events:
    'click #next': 'nextWord'
    'click #prev': 'prevWord'
    'click #flip': 'flip'
    'click #shuffle': 'render'

  render: ->
    @words = @collection.shuffleWords()
    @index = 0
    @showing = 'word'
    $(@el).html(@template(word: @words[@index], showing: @showing))
    this

  nextWord: ->
    @showing = 'word'

    if @index+1 < @words.length
      @index += 1
      $(@el).html(@template(word: @words[@index], showing: @showing))

  prevWord: ->
    @showing = 'word'

    if @index > 0
      @index -= 1
      $(@el).html(@template(word: @words[@index], showing: @showing))

  flip: ->
    if @showing == 'word'
      @showing = 'def'
    else
      @showing = 'word'

    $(@el).html(@template(word: @words[@index], showing: @showing))
