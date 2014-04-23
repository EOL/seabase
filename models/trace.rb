class Trace < ActiveRecord::Base
  belongs_to :gephi_import
  has_many :gephi_records

  def transcript_count
    gephi_records.count
  end
end
