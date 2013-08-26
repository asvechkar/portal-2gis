class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name, :null => false
      t.references :user, index: true

      t.timestamps
    end
  end
end
