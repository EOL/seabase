# Describes experiment point with the slope of the data,
# conditions, time, number of lanes and experiments
class Replicate < ActiveRecord::Base
  belongs_to :taxon
  belongs_to :condition

  def self.all_stages
    # Adding "Hours" here doesn't feel right
    connection.select_values("
      SELECT distinct(rs.stage)
      FROM replicates rs
      ORDER BY rs.stage"
    ).unshift("Hours")
  end
end
