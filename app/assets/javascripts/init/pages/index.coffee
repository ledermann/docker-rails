class @PagesIndex
  constructor: ->
    $('.table tr[data-href] > td.js-row-link').each ->
      $(this).css('cursor', 'pointer').hover((->
        $(this).parent().addClass 'active'
        return
      ), ->
        $(this).parent().removeClass 'active'
        return
      ).click ->
        Turbolinks.visit $(this).parent().attr('data-href')
        return
      return
    return
