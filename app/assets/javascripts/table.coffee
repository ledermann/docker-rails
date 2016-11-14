$(document).on 'turbolinks:load', ->
  $('.table tr[data-href] td.row-link').each ->
    $(this).css('cursor', 'pointer').hover((->
      $(this).parent().addClass 'active'
      return
    ), ->
      $(this).parent().removeClass 'active'
      return
    ).click ->
      document.location = $(this).parent().attr('data-href')
      return
    return
  return
