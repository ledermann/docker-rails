class @FormValidator
  constructor: ->
    $('form').parsley
      errorClass: 'has-danger'
      successClass: 'has-success'
      errorsWrapper: '<div></div>'
      errorTemplate: '<span class="form-text text-muted"></span>'
      classHandler: (ParsleyField) ->
        ParsleyField.$element.parent()
