class @PagesIndex
  constructor: ->

    $('.table tr[data-href] > td.js-row-link')
      .css('cursor', 'pointer')
      .off('mouseenter').on('mouseenter', ->
        $(this).parent().addClass 'active'
        return
      ).off('mouseleave').on('mouseleave', ->
        $(this).parent().removeClass 'active'
        return
      ).off('click').on 'click', ->
        Turbolinks.visit $(this).parent().attr('data-href')
        return
