class AddColumnToUsers < ActiveRecord::Migration
  def change
    
    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    # t.string   :confirmation_token
    # t.datetime :confirmed_at
    # t.datetime :confirmation_sent_at
    # t.string   :unconfirmed_email # Only if using reconfirmable

    ## Lockable
    add_column :users, :failed_attempts, :integer, :default => 0
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
    # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
    # t.string   :unlock_token # Only if unlock strategy is :email or :both
    # t.datetime :locked_at

    ## Token authenticatable
    add_column :users, :authentication_token, :string
    # t.string :authentication_token
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end
end
