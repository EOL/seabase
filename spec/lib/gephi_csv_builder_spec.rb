describe Seabase::GephiCsvBuilder do
  subject { Seabase::GephiCsvBuilder.new(path_out) }
  let(:path_out) { '/tmp/seabase.csv' }

  describe '.new' do
    it 'initializes' do
      `touch #{path_out}`
      expect(File.exists?(path_out)).to be true
      expect(subject).to be_kind_of Seabase::GephiCsvBuilder 
      expect(File.exists?(path_out)).to be false
    end

    context 'wrong file extension' do
      let(:path_out) { '/tmp/sebase.gif' }

      it 'should raise FileExtensionError' do
        expect{subject}.to raise_error Seabase::FileExtensionError
        expect{subject}.to raise_error 'CSV file should end with .csv'
      end
    end
  end

  describe '#open' do 
    it 'creates empty file' do
      subject.start
      expect(File.exists?(path_out)).to be true
      expect(File.read(path_out)).to eq ''
      subject.stop
    end
  end

  describe '#add_row' do
    it 'creates one new row' do
      subject.start
      subject.add_row([1, 2, 0.99])
      subject.stop
      expect(File.read(path_out)).to eq(
        "http://seabase.core.cli.mbl.edu/transcript/1;"\
        "http://seabase.core.cli.mbl.edu/transcript/2\n" 
      )
    end
  end
end

