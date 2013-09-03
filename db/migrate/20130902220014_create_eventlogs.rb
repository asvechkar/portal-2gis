class CreateEventlogs < ActiveRecord::Migration
  def change
    create_table :eventlogs do |t|
      t.string :action
      t.string :model
      t.text :message
      t.references :user, index: true
      t.integer :status

      t.timestamps
    end
  end
end
