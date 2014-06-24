class Mission < ActiveRecord::Base
  has_many :users

  validates_presence_of :name, :description
end
