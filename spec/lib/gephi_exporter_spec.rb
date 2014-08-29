describe Seabase::GephiExporter do
  subject(:ge) { Seabase::GephiExporter.new(path_in: path_in, 
                                            path_out: path_out,
                                            threshold: threshold,
                                            format: format) }
  let(:path_in) { File.expand_path('../../files/similarities.tsv', __FILE__) }
  let(:path_out) { '/tmp/seabase.gexf' }
  let(:threshold) { 0.9 }
  let(:format) { 'gexf' }

  describe '.new' do
    it 'initializes' do
      `touch #{path_out}`
      expect(File.exists?(path_out)).to be true
      expect(ge).to be_kind_of Seabase::GephiExporter
      expect(File.exist?(path_out)).to be false
    end
  end

  describe '#export' do
    context 'gephi gexf format' do
      it 'converts similarity file to gexf file' do
        expect(File.exist?(path_out)).to be false
        ge.export
        expect(File.exists?(path_out)).to be true
        data = Nokogiri::XML.parse(File.read path_out)
        expect(data.root.name).to eq 'gexf'
      end
    end
  end
end
