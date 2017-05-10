class Init
  constructor: ->
    page = $('body').data('page')
    @execute(page)

  execute: (page) ->
    if 'function' is typeof window[page]
      klass = window[page]
      new klass()

$(document).on 'turbolinks:load', ->
  autosize $('textarea')

  new Init()
