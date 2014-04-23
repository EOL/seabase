describe GephiImport do
  subject { GephiImport }

  describe '.process_file' do
    
    let(:file_path) { File.join(__dir__, '..', 'files', 'gephi_export.csv') }
    let(:name) { 'Nematostella transcripts' }

    before(:each) { truncate_db }

    it 'processes csv file' do
      expect(GephiImport.count).to eq 0
      expect(Trait.count).to eq 0
      expect(GephiRecord.count).to eq 0
      gi = subject.process_file(file_path, name)
      expect(GephiImport.count).to eq 1
      expect(Trait.count).to eq 7 
      expect(GephiRecord.count).to eq 102
      expect(gi).to be_kind_of(GephiImport)
    end

  end

end
