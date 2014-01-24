class Transcript < ActiveRecord::Base
  def table_items
    Seabase::Normalizer.new(Replicate.all(), 
                            [self], 
                            Transcript.connection.select_rows("
                              SELECT mc.mapping_count, mc.replicate_id, #{id}
                              FROM mapping_counts mc
                              WHERE mc.transcript_id = #{id}")).table
  end
end
