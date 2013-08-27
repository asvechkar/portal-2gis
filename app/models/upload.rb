class Upload < ActiveRecord::Base
  belongs_to :user
  has_attached_file :upload

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
        "id" => self.id,
        "name" => read_attribute(:upload_file_name),
        "size" => read_attribute(:upload_file_size),
        "url" => upload.url(:original),
        "delete_url" => upload_path(self),
        "delete_type" => "DELETE"
    }
  end


  def classname
    true
  end

end