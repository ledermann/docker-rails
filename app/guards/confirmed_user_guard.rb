class ConfirmedUserGuard < Clearance::SignInGuard
  def call
    if unconfirmed?
      failure I18n.t("flashes.failure_when_not_confirmed")
    else
      next_guard
    end
  end

  def unconfirmed?
    signed_in? && !current_user.confirmed?
  end
end
