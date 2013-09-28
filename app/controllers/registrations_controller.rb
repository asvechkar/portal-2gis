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
end
