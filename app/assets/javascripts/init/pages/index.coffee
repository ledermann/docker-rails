class @PagesIndex
  constructor: ->
    # Make rows (means: cells with class js-row-link) clickable
    $('.table tr[data-href] > td.js-row-link')
      .css('cursor', 'pointer')
      .off('click').on 'click', ->
        Turbolinks.visit $(this).parent().attr('data-href')
        return
