class UploadsController < ApplicationController
  before_action :set_uploads, only: [:show, :edit, :update, :destroy]

  def index
    @uploads = Upload.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    #@upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    #@upload = Upload.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create

    if params[:upload]
      @upload = Upload.new(uploads_params)
      respond_to do |format|
        if @upload.save
          format.html {
            render :json => [@upload.to_jq_upload].to_json,
                   :content_type => 'text/html',
                   :layout => false
          }
          format.json { render json: {files: [@upload.to_jq_upload]}, status: :created, location: @upload }
        else
          format.html { render action: "new" }
          format.json { render json: @upload.errors, status: :unprocessable_entity }
        end
      end
    else

    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    #@upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(uploads_params)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    #@upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_uploads
    @upload = Upload.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def uploads_params
    params.require(:upload).permit(:upload)
  end
end
