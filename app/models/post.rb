class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :state

  validates :title, :content, :user, presence: true

  def has_destroy_permissions(user)
    user.class == User &&
      (
        user == self.user ||
        self.state.project.has_admin_permissions(user)
      )
  end

  def has_put_permissions(user)
    # for now, anybody who can delete should be
    # able to update the post as well
    has_destroy_permissions user
  end
end
