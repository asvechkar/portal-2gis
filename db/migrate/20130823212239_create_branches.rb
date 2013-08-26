class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name, :null => false
      t.references :city, index: true
      t.references :employee, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
