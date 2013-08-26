class CreateUserifications < ActiveRecord::Migration
  def change
    create_table :userifications do |t|
      t.belongs_to :user
      t.belongs_to :userable, polymorphic: true
    end
    add_index :userifications, [:userable_id, :userable_type, :user_id], :name => 'userification_index'
  end
end
