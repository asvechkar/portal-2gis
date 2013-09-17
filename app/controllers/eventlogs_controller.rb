class EventlogsController < ApplicationController
  before_action :set_eventlog, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /eventlogs
  # GET /eventlogs.json
  def index
    @eventlogs = Eventlog.all.order('created_at DESC').page(params[:page]).per(25)
  end

  # GET /eventlogs/1
  # GET /eventlogs/1.json
  def show
  end

  # GET /eventlogs/new
  def new
    @eventlog = Eventlog.new
  end

  # GET /eventlogs/1/edit
  def edit
  end

  # POST /eventlogs
  # POST /eventlogs.json
  def create
    @eventlog = current_user.eventlogs.new(eventlog_params)

    respond_to do |format|
      if @eventlog.save
        format.html { redirect_to @eventlog, notice: 'Eventlog was successfully created.' }
        format.json { render action: 'show', status: :created, location: @eventlog }
      else
        format.html { render action: 'new' }
        format.json { render json: @eventlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eventlogs/1
  # PATCH/PUT /eventlogs/1.json
  def update
    respond_to do |format|
      if @eventlog.update(eventlog_params)
        format.html { redirect_to @eventlog, notice: 'Eventlog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @eventlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eventlogs/1
  # DELETE /eventlogs/1.json
  def destroy
    @eventlog.destroy
    respond_to do |format|
      format.html { redirect_to eventlogs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eventlog
      @eventlog = Eventlog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eventlog_params
      params.require(:eventlog).permit(:action, :model, :message, :user_id, :status)
    end
end
