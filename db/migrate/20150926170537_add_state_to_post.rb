class AddStateToPost < ActiveRecord::Migration
  def change
    add_reference :posts, :state, index: true
  end
end
