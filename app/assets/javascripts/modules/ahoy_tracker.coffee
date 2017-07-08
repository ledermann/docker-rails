class @AhoyTracker
  constructor: ->
    ahoy.trackView();
    # Avoid tracking events twice
    # https://github.com/ankane/ahoy/issues/243#issuecomment-274373890
    unless window.ahoyDocumentEventTrackersInitialized
      ahoy.trackClicks()
      ahoy.trackSubmits();
      ahoy.trackChanges();
      window.ahoyDocumentEventTrackersInitialized = true
