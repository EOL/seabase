class Transcript < ActiveRecord::Base
  has_many :external_matches
  has_many :external_names, through: :external_matches
  def table_items
    Seabase::Normalizer.new(Replicate.all(), 
                            [self], 
                            Transcript.connection.select_rows("
                              SELECT mc.mapping_count, mc.replicate_id, #{id}
                              FROM mapping_counts mc
                              WHERE mc.transcript_id = #{id}")).table
  end
end
