class @InfiniteScrolling
  constructor: ->
    @disable()
    if $('#js-paging').length
      @enable()

  disable: ->
    $(window).off 'scroll'
    return

  enable: ->
    @getNextPageIfNeeded()
    $(window).on 'scroll', =>
      @getNextPageIfNeeded()
      return
    return

  getNextPageIfNeeded: ->
    if @isInViewport()
      url = $('#js-paging a[rel=next]').attr('href')
      if url
        @disable()
        $.getScript url, ->
          new InfiniteScrolling()
          return
    return

  isInViewport: ->
    # Check if the paginator is visible (i.e. scrolled into the viewport)
    rect = $('#js-paging')[0].getBoundingClientRect()
    rect.top > 0 and rect.top <= (window.innerHeight or document.documentElement.clientHeight)
