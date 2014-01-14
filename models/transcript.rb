class Transcript < ActiveRecord::Base
  def headers
    self.connection.select_values("SELECT distinct(rs.stage)
        FROM replicates rs, mapping_counts mc, external_matches em
        WHERE rs.id = mc.replicate_id
        AND em.transcript_id = #{id}
        ORDER BY rs.stage").unshift("Replicate")
  end
  
  def table_items
    Seabase::Normalizer.new(Replicate.all(), [self], self.connection.select_rows("SELECT mc.mapping_count, mc.replicate_id, #{id}
      FROM mapping_counts mc, external_matches em
      WHERE em.transcript_id = #{id}")).table
  end
end
