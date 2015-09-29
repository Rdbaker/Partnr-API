class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :roles
  has_many :applications, through: :roles

  validates :name, :owner, :creator, presence: true

  attr_readonly :creator

  def has_admin_permissions(user)
    user.class == User && self.owner == user.id
  end

  def has_create_post_permissions(user)
    user.class == User && ( owner == user.id ||
                            roles.any? { |role| role.user == user })
  end
end
