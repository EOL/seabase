describe Seabase do
  subject(:seabase) { Seabase.new }
  
  describe '.version' do
    it 'shows version number' do
      expect(Seabase.version).to match /^\d+\.\d+\.\d+$/
    end

  end

  describe '.new' do
    it 'initializes' do
      expect(seabase).to be_kind_of Seabase
    end
  end

end
