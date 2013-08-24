class Suspension < ActiveRecord::Base
  belongs_to :employed, :polymorphic => true
  belongs_to :employee
end
