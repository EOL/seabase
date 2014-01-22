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

    context 'json' do
      it 'returns results in json' do
        visit('/search.json?scientific_name=Homo+sapiens'\
              '&term=sox&exact_search=false')
        res = JSON.parse(page.body, symbolize_names: true)
        expect(res.map { |r| r[:gene_name] }.sort).
          to eq ['QSOX1', 'SOX14', 'SOX18']
        visit('/search.json?scientific_name=Homo+sapiens'\
              '&term=Transcription&exact_search=false')
        res = JSON.parse(page.body, symbolize_names: true)
        expect(res.map { |r| r[:functional_name] }.sort).
          to eq  ['Transcription factor SOX-14', 'Transcription factor SOX-18']
        visit('/search.json?scientific_name=Homo+sapiens'\
              '&term=O95416&exact_search=false')
        res = JSON.parse(page.body, symbolize_names: true)
        expect(res.map { |r| r[:name] }.sort).
          to eq  ['O95416']
      end
    end
  end

  describe '/external_names' do
    it 'renders' do
      visit '/external_names/25360'
      expect(page.status_code).to eq 200
      expect(page.body).to match 'the human ortholog QSOX1'
    end
  end

  describe '/transcript' do
    it 'renders' do
      visit '/transcript/17065?external_name_id=25360'
      expect(page.status_code).to eq 200
      expect(page.body).to match /transcript comp12135_c0_seq1.+ QSOX1/m
    end
  end
  
end


