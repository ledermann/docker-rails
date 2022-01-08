import { Controller } from '@hotwired/stimulus';
import $ from 'jquery';

export default class extends Controller {
  static targets = ['paging']

  connect() {
    this.disable();

    if (this.hasPagingTarget) {
      this.enable();
    }
  }

  disable() {
    $(window).off('scroll');
  }

  enable() {
    this.getNextPageIfNeeded();
    $(window).on('scroll', () => {
      this.getNextPageIfNeeded();
    });
  }

  getNextPageIfNeeded() {
    if (this.isInViewport()) {
      const url = $(this.pagingTarget).find('a[rel=next]').attr('href');
      if (url) {
        this.disable();
        $.getScript(url, () => {
          this.enable();
        });
      }
    }
  }

  isInViewport() {
    // Check if the paginator is visible (i.e. scrolled into the viewport)
    const rect = this.pagingTarget.getBoundingClientRect();
    return (rect.top > 0)
           && (rect.top <= (window.innerHeight || document.documentElement.clientHeight));
  }
}
