class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_parameters, only: :create
  before_filter :configure_account_update_parameters, only: :update

  def regenerate_api_key
    current_user.api_key = User.generate_api_key
    current_user.save
    flash[:notice] = 'Your API Key has been updated.'
    redirect_to :authenticated_root
  end

  protected

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
end