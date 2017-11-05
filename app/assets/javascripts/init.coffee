class @Init
  constructor: ->
    new AhoyTracker()

    # Forms
    new FormValidator()
    new Upload()

    # Lists
    new InfiniteScrolling()

    # General
    new TimeFormatter()
    new TooltipEnabler()
    new Autocomplete()

$(document).on 'turbolinks:load', ->
  new Init()
