class Posts
  index: ->
    new TableRowLink()

  edit: ->
    new FormValidator()
    new Upload()

  new: ->
    new FormValidator()
    new Upload()

Punchbox.on('Posts', Posts)
