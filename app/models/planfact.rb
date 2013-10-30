class Planfact < ActiveRecord::Base

  belongs_to :planfactable, polymorphic: true

end
