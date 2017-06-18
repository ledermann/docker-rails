class @Upload
  constructor: ->
    $('[type=file]').fileupload

      add: (e, data) -> # Upload begins
        # Disable form submit
        $(this).closest('form').find('input[type=submit]').attr('disabled', true)

        # Display image while uploading
        file = data.files[0]
        reader = new FileReader()
        reader.onload = (e) ->
          $('#image-preview').attr('src', e.target.result)
        reader.readAsDataURL file

        # Add Progressbar
        data.fileinput_button = $(this).closest('.fileinput-button')
        data.fileinput_button.hide()
        data.progressBar = $('<div class="progress w-100 mt-2">
                                <div class="progress-bar" role="progressbar" style="height:50px">
                                </div>
                              </div>').insertAfter(data.fileinput_button)

        # Presign file
        options =
          extension: file.name.match(/(\.\w+)?$/)[0]
          _: Date.now()
        $.getJSON '/upload/cache/presign', options, (result) ->
          data.formData = result.fields
          data.url = result.url
          data.paramName = 'file'
          data.submit()
          return
        return

      progress: (e, data) -> # Upload in progress
        # Update the progressbar
        progress = parseInt(data.loaded / data.total * 100, 10)
        percentage = progress.toString() + '%'
        data.progressBar.find('.progress-bar').css('width', percentage)
        return

      done: (e, data) -> # Upload is done
        # Remove the progressbar
        data.progressBar.remove()

        # Add image id with metadata as value to hidden input field
        image =
          id: data.formData.key.match(/cache\/(.+)/)[1]
          storage: 'cache'
          metadata:
            size: data.files[0].size
            filename: data.files[0].name.match(/[^\/\\]+$/)[0]
            mime_type: data.files[0].type
        $('#post_image').val(JSON.stringify(image))

        # Enable form submit
        $(this).closest('form').find('input[type=submit]').attr('disabled', false)
        data.fileinput_button.show()

    return
