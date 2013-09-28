class SessionsController < Devise::SessionsController
  layout 'registration'
  def create
    super
  end
end
