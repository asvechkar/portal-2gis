class Userification < ActiveRecord::Base
  belongs_to :userable, :polymorphic => true
  belongs_to :user
end
