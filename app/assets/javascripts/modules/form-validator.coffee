class @FormValidator
  constructor: ->
    $('form').parsley
      errorClass: 'has-error'
      successClass: 'has-success'
      errorsWrapper: '<div></div>'
      errorTemplate: '<span class="help-block"></span>'
      classHandler: (ParsleyField) ->
        ParsleyField.$element.parent()
