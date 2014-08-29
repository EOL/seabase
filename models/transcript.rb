# Describes sequenced transcripts from the embryo
class Transcript < ActiveRecord::Base
  has_many :external_matches
  has_many :external_names, through: :external_matches
  has_many :normalized_counts
  def table_items
    Seabase::Normalizer.new(
      Replicate.all,
      [self],
      Transcript.connection.select_rows("
        SELECT mc.mapping_count, mc.replicate_id, #{id}
        FROM mapping_counts mc
        WHERE mc.transcript_id = #{id}"
      )
    ).table
  end

  def fasta_sequence
    format(">%s\n%s", name, transcript_sequence)
  end

  def vector
    Transcript.connection.select_values("
      SELECT sum(count)
      FROM normalized_counts
      WHERE transcript_id = #{id}
      GROUP BY stage
      ORDER BY stage"
    )
  end

  def similarity(transcript)
    Seabase::CosineSimilarity.calculate(vector, transcript.vector)
  end
end
