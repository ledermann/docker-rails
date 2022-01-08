/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'trix';
import 'trix/dist/trix.css';
import 'CSSBox/cssbox.css';

// Bootstrap
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap/dist/js/bootstrap';
import '../styles/theme.scss';

// Load Stimulus controllers
import '../controllers';

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import '../channels';

Rails.start();
Turbolinks.start();
