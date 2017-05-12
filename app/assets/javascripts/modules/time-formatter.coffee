class @TimeFormatter
  constructor: ->
    $('time').text ->
      moment($(@).attr('datetime')).fromNow()
