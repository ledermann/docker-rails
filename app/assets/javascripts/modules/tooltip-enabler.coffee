class @TooltipEnabler
  constructor: ->
    unless ('ontouchstart' of window)
      $('[data-toggle="tooltip"]').tooltip
        container: 'body'

# Avoid tooltips to be visible on using browser's back button
document.addEventListener 'turbolinks:before-cache', ->
  $('[data-toggle="tooltip"]').tooltip('destroy')
  return
