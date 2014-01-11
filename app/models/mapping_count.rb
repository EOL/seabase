class MappingCount < ActiveRecord::Base
  belongs_to :replicate
  belongs_to :transcript
end
