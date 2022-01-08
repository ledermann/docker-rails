import { Controller } from '@hotwired/stimulus';
import $ from 'jquery';

export default class extends Controller {
  connect() {
    if (!this.isTouchDevice()) {
      $('[data-toggle="tooltip"]').tooltip({
        container: 'body',
      });

      $(document).on('turbolinks:before-cache', () => {
        $('[data-toggle="tooltip"]').tooltip('dispose');
      });
    }
  }

  isTouchDevice() {
    return ('ontouchstart' in window);
  }
}
