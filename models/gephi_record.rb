# Registers one network relationship and score for Gephi
class GephiRecord < ActiveRecord::Base
  belongs_to :trace
end
