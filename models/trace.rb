class Trace < ActiveRecord::Base
  belongs_to :gephi_import
  has_many :gephi_records
end
