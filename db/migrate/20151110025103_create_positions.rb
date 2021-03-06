class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :title, null: false
      t.string :company
      t.references :profile, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
