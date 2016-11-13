$(document).on 'turbolinks:load', ->
  $('.table tr[data-href]').each ->
    $(this).css('cursor', 'pointer').hover((->
      $(this).addClass 'active'
      return
    ), ->
      $(this).removeClass 'active'
      return
    ).click ->
      document.location = $(this).attr('data-href')
      return
    return
  return
