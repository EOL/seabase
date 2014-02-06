describe '/blast', js: true do

  it 'renders' do 
    visit '/blast'
    expect(page.status_code).to eq 200
    expect(page.body).to match 'Blast'
  end

  context 'blast from file' do
    it 'performs search of file' do
      if os == 'linux'
        visit '/blast'
        attach_file('SEQFILE', 
                    File.expand_path(File.join(%w(.. .. 
                        files pcna_fasta.txt)), __FILE__))
        click_button('run_blast_1')
        expect(page.status_code).to eq 200
        expect(page.body).to match /aacttggaaatggaaaca/ 
      end
    end
  end

  context 'blast from string' do
    it 'perform search on string' do
      if os == 'linux'
        visit '/blast'
        fill_in('SEQUENCE', with: 'GGATACCTTGGCGCTAGTATTT')
        click_button('run_blast_1')
        expect(page.status_code).to eq 200
        expect(page.body).to match /tggcgctagtattt/
      end
    end

    it 'returns empty result if nothing is found' do
      if os == 'linux'
        visit '/blast'
        fill_in('SEQUENCE', with: 'TTTTTT')
        click_button('run_blast_1')
        expect(page.status_code).to eq 200
        expect(page.body).to match /No hits found/
      end
    end

    it 'returns Blast error if empty string is entered' do
      if os == 'linux'
        visit '/blast'
        fill_in('SEQUENCE', with: '')
        click_button('run_blast_1')
        expect(page.status_code).to eq 200
        expect(page.body).not_to match /No matches/
        expect(page.body).to match 'Error 8 in submitting BLAST query'
      end
    end
  end

end


