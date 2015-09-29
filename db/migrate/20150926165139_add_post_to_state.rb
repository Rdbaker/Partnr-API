class AddPostToState < ActiveRecord::Migration
  # this is the way adding references should be done
  # from the command `rails g migration AddPostToState post:references`
  def change
    add_reference :states, :post, index: true
  end
end
