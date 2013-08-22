class RegistrationsController < Devise::RegistrationsController
  layout 'registration'

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  protected

    def after_sign_up_path_for(resource)
      new_user_session_path
    end

    def after_inactive_sign_up_path_for(resource)
      new_user_session_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email) }
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end
end
