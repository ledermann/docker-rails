class @InfinitiveScrolling
  constructor: ->
    @disable()
    if $('.pagination').length
      @enable()

  disable: ->
    $(window).off 'scroll'
    return

  enable: ->
    $(window).on 'scroll', =>
      url = $('.pagination a[rel=next]').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 200
        @disable()
        $.getScript url, ->
          new Init()
          return
      return
    return
