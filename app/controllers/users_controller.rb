class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      ClearanceMailer.registration_confirmation(@user).deliver_later
      flash[:notice] = t('flashes.confirmation_requested')
      redirect_back_or url_after_create
    else
      render template: 'users/new'
    end
  end

  def confirm
    user = User.find_by(id: params[:user_id])

    unless user
      redirect_to root_path, alert: t('flashes.failure_confirmation')
      return
    end

    if user.confirmed?
      redirect_to root_path, notice: t('flashes.already_confirmed')
      return
    end

    if user.confirm_with_token(params[:token])
      redirect_to sign_in_path, notice: t('flashes.confirmed_registration')
    else
      redirect_to root_path, alert: t('flashes.failure_confirmation')
    end
  end
end
