describe Seabase::Normalizer do
  let(:transcript) { Transcript.where("name = 'comp10858_c0_seq1'").first }
  let(:id) { transcript.id }
  subject(:normalizer) { Seabase::Normalizer.new(Replicate.all(), [transcript], 
    Transcript.connection.select_rows("SELECT mc.mapping_count, mc.replicate_id, #{id}
    FROM mapping_counts mc
    WHERE mc.transcript_id = #{id}")) }
  let(:table) { normalizer.table }
  
  describe '.new' do
    it 'initializes' do
      expect(normalizer).to be_kind_of Seabase::Normalizer
    end    
  end

  describe '.table' do
    it 'has data' do
      expect(table).to be_kind_of Array
      expect(table.length).to eq 3
      expect(table[0]).to be_kind_of Array
      expect(table[0].length).to eq Replicate.all_stages.length
      expect(table[0][0]).to eq "A"
    end
  end
end
