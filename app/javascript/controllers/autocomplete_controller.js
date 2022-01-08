import { Controller } from '@hotwired/stimulus';
import autocomplete from 'autocompleter';
import 'autocompleter/autocomplete.css';

export default class extends Controller {
  connect() {
    const inputElement = this.element;

    autocomplete({
      input: inputElement,
      emptyMsg: 'No items found',

      fetch(text, update) {
        // Query JSON API, which returns words
        fetch(`/api/v1/posts/autocomplete?q=${text}`)
          .then((response) => response.json())
          .then((words) => update(words));
      },

      render(item) {
        const div = document.createElement('div');
        div.textContent = item;
        return div;
      },

      onSelect(item) {
        inputElement.value = item;
      },
    });
  }
}
