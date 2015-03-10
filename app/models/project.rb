class Project < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name, :owner, :creator, presence: true

  def has_admin_permissions(user)
    user.class == User && self.owner == user.id
  end
end
