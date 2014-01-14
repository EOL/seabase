class Replicate < ActiveRecord::Base
  belongs_to :taxon
  belongs_to :condition

  def self.all_stages
    self.connection.select_values("SELECT distinct(rs.stage)
        FROM replicates rs
        ORDER BY rs.stage").unshift("Hours")
  end

end
