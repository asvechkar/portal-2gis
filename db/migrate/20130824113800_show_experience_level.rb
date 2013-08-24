class ShowExperienceLevel < ActiveRecord::Migration
  def change
    add_column :positions, :show_experience_level, :integer
  end
end
