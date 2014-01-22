describe SeabaseApp do
  describe '/' do
    it 'renders' do
      visit '/'
      expect(page.status_code).to eq 200
      expect(page.body).to match 'SeaBase'
    end
  end

  describe '/blast' do
    it 'renders' do 
      visit '/blast'
      expect(page.status_code).to eq 200
      expect(page.body).to match 'Blast'
    end
  end

  describe '/search' do
    it 'renders' do
      visit '/search'
      expect(page.status_code).to eq 200
      expect(page.body).to match %q(For example 'polymerase alpha', 'P17918')
    end
  end

  describe '/external_names' do
    it 'renders' do
      visit '/external_names/25360'
      expect(page.status_code).to eq 200
      expect(page.body).to match 'the human ortholog QSOX1'
    end
  end
  
end


