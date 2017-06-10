class @Autocomplete
  constructor: ->
    posts = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.whitespace
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: '/posts/autocomplete?q=%QUERY'
        wildcard: '%QUERY')

    $('#autocomplete').typeahead(
      minLength: 2
      highlight: true
    ,
      source: posts
    ).keypress (e) ->
      if e.which == 13
        $(this).closest("form").submit()
      return
