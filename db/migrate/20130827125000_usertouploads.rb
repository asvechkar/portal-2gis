class Usertouploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :user_id, :integer
  end
end
