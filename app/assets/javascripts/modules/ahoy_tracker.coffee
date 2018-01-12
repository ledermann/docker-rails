class @AhoyTracker
  constructor: ->
    # These methods call document.on('event') and should not be called
    # more than once per lifecycle of document.
    # https://github.com/ankane/ahoy/issues/243#issuecomment-274373890
    unless window.ahoyDocumentEventTrackersInitialized
      ahoy.trackClicks()
      ahoy.trackSubmits()
      ahoy.trackChanges()
      window.ahoyDocumentEventTrackersInitialized = true

    # Should be called once per page load.
    ahoy.trackView()
