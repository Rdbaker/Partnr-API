class RemoveProfileFromSkills < ActiveRecord::Migration
  def change
    remove_column :skills, :profile_id
  end
end
