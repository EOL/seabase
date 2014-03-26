describe Seabase::CosineSimilarity do

  describe '.cosine_measure' do

    subject(:cosim) { Seabase::CosineSimilarity.calculate(v1, v2) }

    context 'matching vectors' do
      let (:v1) { [0, 44, 2, 7, 25, 30] }
      let (:v2) { [0, 88, 4, 14, 50, 60] }
      it { should eq 1.0 }
    end

    context 'opposite vectors' do
      let (:v1) { [0, 44, 2, 7, 25, 30] }
      let (:v2) { [0, -88, -4, -14, -50, -60] }
      it { should eq -1.0 }
    end

    context 'similar vectors' do
      let (:v1) { [0, 40.3, 1.5, 6.8, 27, 29] }
      let (:v2) { [0, 79.44, 1, 10, 30, 57] }
      it { should eq 0.98 }
    end
    
    context 'similar vectors in oppsite order' do
      let (:v1) { [0, 79.44, 1, 10, 30, 57] }
      let (:v2) { [0, 40.3, 1.5, 6.8, 27, 29] }
      it { should eq 0.98 }
    end

    context 'dissimilar vectors' do 
      let (:v1) { [40.3, 0, 15, 0.8, 7, 1157] }
      let (:v2) { [0, 79.44, 1, 10, 30, 1] }
      it { should eq 0.014 }
    end

    context 'externally calculated vectors' do
      let(:v1) { [-0.012813841, -0.024518383, -0.002765056,  
                  0.079496744,  0.063928973, 0.476156960,  
                  0.122111977,  0.322930189,  0.400701256,  
                  0.454048860, 0.525526219] }

      let(:v2) { [0.64175768,  0.54625694,  0.40728261,  
                  0.24819750,  0.09406221, 0.16681692, 
                  -0.04211932, -0.07130129, -0.08182200, 
                  -0.08266852, -0.07215885] }
      it { should eq -0.054 }
    end
  
    context 'similar vectors with mismatched nulls' do
      let (:v1) { [0, 40.3, nil, 6.8, 27, 29] }
      let (:v2) { [0, 79.44, 1, 10, 30, 57] }
      it { should eq 0.98 }
    end
    
    context 'similar vectors with matched nulls' do
      let (:v1) { [0, 40.3, nil, 6.8, 27, 29] }
      let (:v2) { [0, 79.44, nil, 10, 30, 57] }
      it { should eq 0.98 }
    end
  end

end
