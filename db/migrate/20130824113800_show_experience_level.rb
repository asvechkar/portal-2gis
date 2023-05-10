class ShowExperienceLevel < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :show_experience_level, :integer
  end
end
