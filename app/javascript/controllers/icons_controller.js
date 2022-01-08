import { Controller } from '@hotwired/stimulus';

import { library, dom } from '@fortawesome/fontawesome-svg-core';
import { faHome } from '@fortawesome/free-solid-svg-icons/faHome';
import { faPlus } from '@fortawesome/free-solid-svg-icons/faPlus';
import { faSpinner } from '@fortawesome/free-solid-svg-icons/faSpinner';
import { faImage } from '@fortawesome/free-solid-svg-icons/faImage';
import { faCogs } from '@fortawesome/free-solid-svg-icons/faCogs';
import { faBinoculars } from '@fortawesome/free-solid-svg-icons/faBinoculars';
import { faUserCircle } from '@fortawesome/free-solid-svg-icons/faUserCircle';
import { faUserPlus } from '@fortawesome/free-solid-svg-icons/faUserPlus';
import { faEdit } from '@fortawesome/free-solid-svg-icons/faEdit';
import { faTrashAlt } from '@fortawesome/free-solid-svg-icons/faTrashAlt';
import { faSearch } from '@fortawesome/free-solid-svg-icons/faSearch';

export default class extends Controller {
  initialize() {
    library.add(
      faHome,
      faPlus,
      faSpinner,
      faImage,
      faCogs,
      faBinoculars,
      faUserCircle,
      faUserPlus,
      faEdit,
      faTrashAlt,
      faSearch,
    );
  }

  connect() {
    dom.watch();
  }
}
