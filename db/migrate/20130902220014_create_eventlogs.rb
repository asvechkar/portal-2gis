class CreateEventlogs < ActiveRecord::Migration[5.2]
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
