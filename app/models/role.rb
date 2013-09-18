class Role < ActiveRecord::Base
  has_and_belongs_to_many :users,
                          :join_table => :users_roles,
                          :foreign_key => 'role_id',
                          :association_foreign_key => 'user_id'
  belongs_to :resource, :polymorphic => true
  validates_presence_of :name
  validates_uniqueness_of :name
  scopify
end
