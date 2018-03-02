# Track visitors with Piwik
# Based on https://gist.github.com/erpe/8586565

class @PiwikAnalytics
  constructor: ->
    return unless @piwikHost() and @piwikId()

    # Piwik Analytics depends on a global _paq array. window is the global scope.
    window._paq = []
    window._paq.push(['setTrackerUrl', @piwikUrl()])
    window._paq.push(['setSiteId', @piwikId()])
    window._paq.push(['enableLinkTracking'])

    # Create a script element and insert it in the DOM
    pa = document.createElement('script')
    pa.type = 'text/javascript'
    pa.defer = true
    pa.async = true
    pa.src = @piwikUrl()
    firstScript = document.getElementsByTagName('script')[0]
    firstScript.parentNode.insertBefore pa, firstScript

    # If Turbolinks is supported, set up a callback to track pageviews on turbolinks:load.
    # If it isn't supported, just track the pageview now.
    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      document.addEventListener 'turbolinks:load', (=>
        @trackPageView()
      ), true
    else
      @trackPageView()

  trackPageView: ->
    window._paq.push ['setCustomUrl', document.location]
    window._paq.push ['setDocumentTitle', document.title]
    window._paq.push ['trackPageView']

  piwikId: ->
    $("meta[name='piwik-id']").attr('content')

  piwikHost: ->
    $("meta[name='piwik-host']").attr('content')

  piwikUrl: ->
    '//' + @piwikHost() + '/js/'
