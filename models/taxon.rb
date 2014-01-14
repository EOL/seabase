class Taxon < ActiveRecord::Base
  SN_TO_ON = {
    'Homo sapiens' => 'Human',
    'Mus musculus' => 'Mouse',
    'Nematostella vectensis' => 'Nematostella'
  }
  
  def self.scientific_name_to_ortholog_name(name)
    SN_TO_ON[name]
  end
end
