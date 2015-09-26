class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.column :name, :string, null: false
      t.belongs_to :project, :integer, index: true

      t.timestamps
    end

    add_column :projects, :state_id, :integer
  end
end
