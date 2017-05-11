class @Init
  constructor: ->
    page = $('body').data('page')
    @execute(page)

    new TextAreaAutosize()
    new FormValidator()
    new InfiniteScrolling()

  execute: (page) ->
    if 'function' is typeof window[page]
      klass = window[page]
      new klass()

$(document).on 'turbolinks:load', ->
  new Init()
