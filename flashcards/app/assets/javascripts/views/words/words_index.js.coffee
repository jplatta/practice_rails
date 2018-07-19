class GreWords.Views.WordsIndex extends Backbone.View

  template: JST['words/index']
  addword: JST['words/addword']

  events:
    'submit #new_word': 'defineForm'
    'submit #new_def': 'createWord'
    'click #nav_quiz': 'startQuiz'
    'click #nav_words': 'render'
    'reset #new_word_form_container': 'render'

  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @appendWord, this)

  render: ->
    $(@el).html(@template())
    $('#new_word_form_container').append(@addword(item: true))
    $('#nav_words').addClass("active_button")
    $('#nav_quiz').removeClass("active_button")
    @collection.comparator = "word"
    @collection.each(@appendWord, this)
    this

  appendWord: (word) ->
    view = new GreWords.Views.Word(model: word)
    this.$('#words').append(view.render().el)

  defineForm: (event) ->
    event.preventDefault()
    @word = $('#add_word').val()
    this.$('#new_word_form').replaceWith(@addword(item: false))

  createWord: (event) ->
    event.preventDefault()

    attributes = { word: @word, definition: $('#add_def').val() }

    @collection.create(new GreWords.Models.Word({word: attributes}),
      wait: true,
      success: -> $('#new_word_form_container').trigger("reset")
      error: @handleError
      )

  handleError: (word, response) ->
    if response.status == 422
      errors = $.parseJSON(response.responseText).errors
      for attribute, messages of errors
        alert "#{attribute} #{message}" for message in messages
    $('#new_word_form_container').trigger("reset")

  startQuiz: (event) ->
    event.preventDefault()
    $('#word_list').remove()
    $('#nav_quiz').addClass("active_button")
    $('#nav_words').removeClass("active_button")

    view = new GreWords.Views.WordsQuiz(collection: @collection)
    $('#quiz').html(view.render().el)
