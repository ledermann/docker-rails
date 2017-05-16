require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  helper_method def body_js_class
    @body_js_class ||= [ controller_name.camelcase, action_name.camelcase ].join
  end
end
