class AddStatusToProject < ActiveRecord::Migration
  def change
    add_column :projects, :status, :integer, default: 0, index: true
  end
end
