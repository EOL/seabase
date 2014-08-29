# Precalculated and normalized data of transcripts per embrio
# per experiment repeat per time point
class NormalizedCount < ActiveRecord::Base
  belongs_to :transcript
end
