import { Controller } from '@hotwired/stimulus';
import $ from 'jquery';
import 'parsleyjs';

export default class extends Controller {
  connect() {
    $(this.element).parsley({
      errorClass: 'has-danger',
      successClass: 'has-success',
      errorsWrapper: '<div></div>',
      errorTemplate: '<span class="form-text text-danger"></span>',
      classHandler(ParsleyField) {
        return ParsleyField.$element.parent();
      },
    });
  }
}
