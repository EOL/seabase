class Replicate < ActiveRecord::Base
  belongs_to :taxon
  belongs_to :condition
end
