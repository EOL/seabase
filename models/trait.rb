class Trait < ActiveRecord::Base
  belongs_to :gephi_import
  has_many :gephi_recors
end
