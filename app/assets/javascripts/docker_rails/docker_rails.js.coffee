#= require_self
#= require_tree .

window.DockerRails =
  configs:
    turbolinks: true # True to use initjs with Turbolinks by default.
    pjax: false # True to use initjs with pjax by default.
    respond_with: # To not use respond_with, just set false.
      'Create': 'New' # Respond the Create action with the New.
      'Update': 'Edit' # Respond the Update action with the Edit.

  initPage: ->
    # If you're using the Turbolinks or pjax and you need run a code once, put something here.
    # if you're not using the turbolinks or pjax, there's no difference between init and initPage.

  init: ->
    # Something here. This is called in every page.

  modules: -> [
    # Some modules that will be used on every page.
    DockerRails.TextAreaAutosize
  ]
