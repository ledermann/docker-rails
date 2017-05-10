class @Init
  constructor: ->
    page = $('body').data('page')
    @execute(page)

    new TextAreaAutosize()
    new InfinitiveScrolling()

  execute: (page) ->
    if 'function' is typeof window[page]
      klass = window[page]
      new klass()

$(document).on 'turbolinks:load', ->
  new Init()
