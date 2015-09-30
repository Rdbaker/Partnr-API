class ChangeProjectNameToProjectTitle < ActiveRecord::Migration
  def change
    rename_column :projects, :name, :title
    rename_column :states, :name, :title
  end
end
