/* eslint no-param-reassign: 0 */

import { Controller } from '@hotwired/stimulus';
import $ from 'jquery';

import 'blueimp-file-upload/js/vendor/jquery.ui.widget';
import 'blueimp-file-upload/js/jquery.iframe-transport';
import 'blueimp-file-upload/js/jquery.fileupload';
import loadImage from 'blueimp-load-image/js/load-image';
import tmpl from 'blueimp-tmpl/js/tmpl';
import 'blueimp-file-upload/css/jquery.fileupload.css';

export default class extends Controller {
  connect() {
    $('[type=file]').fileupload({
      limitConcurrentUploads: 3,

      add(e, data) { // Upload begins
        // Disable form submit
        $(this).closest('form').find('input[type=submit]').attr('disabled', true);

        // Display image while uploading
        const file = data.files[0];
        data.context = $(tmpl('template-upload', file));
        $('#js-images').append(data.context);

        loadImage(file, ((img) => {
          data.context.find('img').replaceWith($(img).addClass('img-thumbnail square muted'));
        }), {
          maxWidth: 172,
          maxHeight: 172,
        });

        // Show progressbar
        data.progressBar = data.context.find('.progress');

        // Presign file
        const options = {
          extension: file.name.match(/(\.\w+)?$/)[0],
          _: Date.now(),
        };
        $.getJSON('/api/v1/presign', options, (result) => {
          data.formData = result.fields;
          data.url = result.url;
          data.paramName = 'file';
          data.submit();
        });
      },

      progress(e, data) { // Upload in progress
        // Update the progressbar
        const progress = parseInt((data.loaded / data.total) * 100, 10);
        const percentage = `${progress.toString()}%`;
        data.progressBar.find('.progress-bar').css('width', percentage);
      },

      done(e, data) { // Upload is done
        // Remove the progressbar
        data.progressBar.remove();

        // Remove image muting
        data.context.find('img').removeClass('muted');

        // Add image id with metadata as value to hidden input field
        const image = {
          id: data.formData.key.match(/cache\/(.+)/)[1],
          storage: 'cache',
          metadata: {
            size: data.files[0].size,
            filename: data.files[0].name.match(/[^/\\]+$/)[0],
            mime_type: data.files[0].type,
          },
        };
        data.context.find('input').val(JSON.stringify(image));

        // Enable form submit after last upload is done
        const activeUploads = $('[type=file]').fileupload('active');
        if (activeUploads === 1) {
          return $(this).closest('form').find('input[type=submit]').attr('disabled', false);
        }

        return true;
      },
    });
  }
}
