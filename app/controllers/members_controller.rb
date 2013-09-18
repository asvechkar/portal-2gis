class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @members = Member.all
  end

  def show
  end

  def edit
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to members_path, notice: 'Пользователь был успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @member }
      else
        format.html { render action: 'new' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @member.update(member_params)
        @member.update_attributes(:role_ids => params[:user][:role_ids])
        Tools.write2log(current_user.id, 'Обновление', 'Пользователи', 0, member_params.to_s)
        format.html { redirect_to members_path, notice: 'Пользователь был успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Пользователи', 1, member_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @user.destroy
    # respond_to do |format|
    #   format.html { redirect_to users_url }
    #   format.json { head :no_content }
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(
      :username, 
      :email, 
      :role_id,
      :avatar, 
      :firstname, 
      :lastname,
      :birthdate,
      :gender,
      :about,
      :phone,
      :site,
      :facebook,
      :twitter,
      :skype
    )
  end
end
