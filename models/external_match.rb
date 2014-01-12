class ExternalMatch < ActiveRecord::Base
  belongs_to :taxon
  belongs_to :external_identifier
  belongs_to :transcript
  
  def self.exact_ei_search(scientific_name, term)
    quote_term = self.connection.quote(term)
    query = "SELECT DISTINCT(ei.name)
              FROM external_identifiers ei, external_names en, external_matches em, taxons t
              WHERE ei.id = en.external_identifier_id
              AND en.id = em.external_name_id
              AND t.id = en.taxon_id
              AND t.scientific_name = %s
              AND (ei.name = %s or en.gene_name = %s)" % 
                [self.connection.quote(scientific_name), quote_term, quote_term]
    self.connection.select_values(query)
  end
  
  def self.like_ei_search(scientific_name, term)
    escape_term = self.connection.escape(term)
    query = "SELECT DISTINCT(ei.name), en.gene_name, en.functional_name
    FROM external_identifiers ei, external_names en, external_matches em, taxons t
    WHERE ei.id = en.external_identifier_id
    AND en.id = em.external_name_id
    AND t.id = en.taxon_id
    AND t.scientific_name = %s
    AND (ei.name LIKE '%%s%' or en.gene_name LIKE '%%s%' or en.functional_name LIKE '%%s%')
    LIMIT 100" % [self.connection.escape(scientific_name), escape_term, escape_term, escape_term]
    self.connection.select_values(query)
  end
  
end
