import { Controller } from '@hotwired/stimulus';
import Turbolinks from 'turbolinks';

export default class extends Controller {
  click() {
    const href = this.data.get('href');
    Turbolinks.visit(href);
  }
}
