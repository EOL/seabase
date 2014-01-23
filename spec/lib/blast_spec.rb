describe Seabase::Blast do
  subject(:blast) { Seabase::Blast.new(command, db) }
  let(:command) { 'blastn' }
  let(:db)  { 'nematostella_vectensis_transcriptome' }

  describe '.new' do
    it 'intializes' do
      expect(blast).to be_kind_of Seabase::Blast
    end
  end

  describe '#database_path' do
    it 'find path to blast data' do
      expect(blast.database_path).
        to match %r|seabase.blast.db.nematostella_vectensis_transcriptome|
    end
  end

  describe '#search' do
    let(:seq) { File.read(File.expand_path(File.join(%w(.. .. files
      pcna_fasta.txt), __FILE__))) }
    it 'finds sequence' do
      if os == 'linux'
        res = blast.search(seq)
        expect(res).to be_kind_of Bio::Blast::Report
      end
    end
  end

end


