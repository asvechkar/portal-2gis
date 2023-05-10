class Uploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.string   "upload_file_name"
      t.string   "upload_content_type"
      t.integer  "upload_file_size"
      t.datetime "upload_updated_at"
      t.timestamps
    end
  end
end
