class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_parameters, only: :create
  before_action :configure_account_update_parameters, only: :update
  before_action :ensure_user_authenticated, only: :regenerate_api_key

  def regenerate_api_key
    current_user.api_key = User.generate_api_key
    current_user.save
    flash[:notice] = 'Your API Key has been updated.'
    redirect_to :authenticated_root
  end

  protected

  # :nocov:
  def configure_sign_up_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :full_name, :company)
    end
  end

  def configure_account_update_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :full_name, :company, :current_password)
    end
  end
  # :nocov:

  def ensure_user_authenticated
    unless current_user
      render json: { error: 'Unauthorized - Please get a new key at https://api.trade.gov' }, status: :unauthorized
    end
  end
end
