describe Seabase do
  subject(:seabase) { Seabase.new }
  
  describe '.version' do
    it 'shows version number' do
      expect(Seabase.version).to match /^\d+\.\d+\.\d+$/
    end

  end

  describe '.maxup' do
    it 'finds number reasonable to display on graphs axes' do
      data = [[1234, 1300], [12, 13], [234, 240], [1, 1], [34, 35], [999, 1010]]
      data.each do |n|
        expect(Seabase.maxup(n[0])).to eq n[1]
      end
    end
  end

end
