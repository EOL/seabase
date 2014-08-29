# Describes how transcripts match to proteins from various organisms
class ExternalMatch < ActiveRecord::Base
  belongs_to :taxon
  belongs_to :external_name
  belongs_to :transcript
end
