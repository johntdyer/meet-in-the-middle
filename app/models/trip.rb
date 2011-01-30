class Trip < ActiveRecord::Base
  has_many :participants
end
