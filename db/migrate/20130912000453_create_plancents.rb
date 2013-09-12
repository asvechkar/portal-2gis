class CreatePlancents < ActiveRecord::Migration
  def change
    create_table :plancents do |t|
      t.integer :year
      t.integer :month
      t.references :branch, index: true
      t.references :user, index: true
      t.integer :fromprc
      t.integer :toprc
      t.float :mult

      t.timestamps
    end
  end
end
