class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.datetime :sent
      # message associated with a sender
      t.references :user, index: true

      t.timestamps
    end
  end
end
