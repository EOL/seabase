class ExternalMatch < ActiveRecord::Base
  belongs_to :taxon
  belongs_to :external_identifier
  belongs_to :transcript
end
