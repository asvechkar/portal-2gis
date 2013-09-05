module MembersHelper

  def get_avatar_thumb member_id
    @user = User.find(member_id)
    image_tag(@user.avatar_url('thumb')) if @user.avatar?
  end

end
