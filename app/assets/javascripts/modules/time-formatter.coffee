class @TimeFormatter
  constructor: (context) ->
    $('time', context).text ->
      moment($(@).attr('datetime')).fromNow()
