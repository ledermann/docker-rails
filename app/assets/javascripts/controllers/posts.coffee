class Posts
  index: ->
    new Autocomplete()
    new TableRowLink()

  edit: ->
    new FormValidator()
    new Upload()

  new: ->
    new FormValidator()
    new Upload()

Punchbox.on('Posts', Posts)
