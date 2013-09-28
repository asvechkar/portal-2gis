class PasswordsController < Devise::PasswordsController
  layout 'registration'
  def create
    super
  end

  def update
    super
  end
end
