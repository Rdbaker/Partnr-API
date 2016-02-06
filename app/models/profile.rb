class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :location, :dependent => :destroy
  has_many :school_infos, :dependent => :destroy
  has_many :positions, :dependent => :destroy
  has_many :interests, :dependent => :destroy
end
