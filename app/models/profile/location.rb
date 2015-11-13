class Location < ActiveRecord::Base
  belongs_to :profile
  acts_as_mappable

  attr_accessor :geo_string
end
