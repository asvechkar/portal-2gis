module ApplicationHelper
  def page_title
    @page_title || 'Управление'
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=36"
  end
end
