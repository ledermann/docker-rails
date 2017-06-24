class @Lightbox
  constructor: ->
    $(document).on 'click', '[data-toggle="lightbox"]', (event) ->
      event.preventDefault()
      $(this).ekkoLightbox()
      return
