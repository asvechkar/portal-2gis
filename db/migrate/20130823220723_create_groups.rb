class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :code, :null => false
      t.references :branch, index: true
      t.references :employee, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
