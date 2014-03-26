describe Transcript do

  let(:t1) { Transcript.first }
  let(:t2) { Transcript.last }

  describe '#vector' do
    it 'returns array of averaged horly samples sorted by time' do
      expect(t1.vector).to be_kind_of Array
      expect(t1.vector.size).to eq 20
      expect(t1.vector[0]).to be_close(4.24, 0.01)
    end
  end

  describe '#similarity' do
    it 'returns cosine similarity score between two transcripts' do
      expect(t1.similarity(t2)).to eq 0.856
    end
  end

end
