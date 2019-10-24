import { Controller } from 'stimulus'
import Turbolinks from 'turbolinks'
import $ from 'jquery'

export default class extends Controller {
  // Track visitors with Piwik
  // Based on https://gist.github.com/erpe/8586565

  connect() {
    if (!this.piwikHost() || !this.piwikId()) { return }

    // Piwik Analytics depends on a global _paq array. window is the global scope.
    window._paq = []
    window._paq.push(['disableCookies'])
    window._paq.push(['setTrackerUrl', this.piwikUrl()])
    window._paq.push(['setSiteId', this.piwikId()])
    window._paq.push(['enableLinkTracking'])

    // Create a script element and insert it in the DOM
    const pa = document.createElement('script')
    pa.type = 'text/javascript'
    pa.defer = true
    pa.async = true
    pa.src = this.piwikUrl()
    const firstScript = document.getElementsByTagName('script')[0]
    firstScript.parentNode.insertBefore(pa, firstScript)

    // If Turbolinks is supported, set up a callback to track pageviews on turbolinks:load.
    // If it isn't supported, just track the pageview now.
    if ((typeof Turbolinks !== 'undefined') && Turbolinks.supported) {
      document.addEventListener('turbolinks:load', (() => this.trackPageView()
      ), true)
    } else {
      this.trackPageView()
    }
  }

  trackPageView() {
    window._paq.push(['setCustomUrl', document.location])
    window._paq.push(['setDocumentTitle', document.title])
    return window._paq.push(['trackPageView'])
  }

  piwikId() {
    return $('meta[name=\'piwik-id\']').attr('content')
  }

  piwikHost() {
    return $('meta[name=\'piwik-host\']').attr('content')
  }

  piwikUrl() {
    return `//${this.piwikHost()}/js/`
  }
}
