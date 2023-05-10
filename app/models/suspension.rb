class Suspension < ApplicationRecord
  belongs_to :employed, :polymorphic => true
  belongs_to :employee
end
