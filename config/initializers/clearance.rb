require 'confirmed_user_guard'

Clearance.configure do |config|
  config.routes = false
  config.rotate_csrf_on_sign_in = true
  config.sign_in_guards = [ConfirmedUserGuard]
end
