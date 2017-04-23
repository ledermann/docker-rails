DockerRails.Pages ?= {}

DockerRails.Pages.Index =
  init: ->
    $('.table tr[data-href] td.row-link').each ->
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

  modules: -> []
