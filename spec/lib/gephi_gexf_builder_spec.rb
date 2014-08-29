describe Seabase::GephiGexfBuilder do

  subject { Seabase::GephiGexfBuilder.new(path_out) }
  let(:path_out) { '/tmp/seabase.gexf' }
  let(:t1) { Transcript.first }
  let(:t2) { Transcript.last }

  describe '.new' do
    it 'initializes' do
      `touch #{path_out}`
      expect(File.exists?(path_out)).to be true
      expect(subject).to be_kind_of Seabase::GephiGexfBuilder 
      expect(File.exists?(path_out)).to be false
    end

    context 'wrong file extension' do
      let(:path_out) { '/tmp/sebase.gif' }

      it 'should raise FileExtensionError' do
        expect{subject}.to raise_error Seabase::FileExtensionError
        expect{subject}.to raise_error 'GEXF file should end with .gexf'
      end
    end
  end

  describe '#start' do
    it 'does not create file, creates doc' do
      subject.start
      expect(subject.doc.root.name).to eq 'gexf'
      subject.stop
    end
  end

  describe '#add_row' do
    it 'creates one new row' do
      subject.start
      subject.add_row([t1.id, t2.id, 0.99])
      subject.stop
      expect(File.read(path_out)).
        to match %r|<node id="6844" label="comp10858_c0_seq1"/>|
    end
  end

  describe '#stop' do
    it 'adds footer and closes file' do
    end
  end

end
