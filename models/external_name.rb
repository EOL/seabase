require 'set'

class ExternalName < ActiveRecord::Base
  belongs_to :external_source
  belongs_to :taxon
  has_many :external_matches

  def self.exact_search(scientific_name, term)
    quote_term = self.connection.quote(term)
    ExternalName.find_by_sql("SELECT DISTINCT en.*
      FROM external_names en, external_matches em, taxons t
      WHERE en.id = em.external_name_id
      AND t.id = en.taxon_id
      AND t.scientific_name = %s
      AND (en.name = %s or en.gene_name = %s)" % 
      [self.connection.quote(scientific_name), quote_term, quote_term])
  end
  
  def self.like_search(scientific_name, term, limit)
    escape_term = self.sanitize(term).gsub(/^'(.+)'$/, '\1')
    escape_scientific_name = self.sanitize(scientific_name)
    ExternalName.find_by_sql("SELECT DISTINCT en.*
      FROM external_names en, external_matches em, taxons t
      WHERE en.id = em.external_name_id
      AND t.id = en.taxon_id
      AND t.scientific_name = %s
      AND (en.name LIKE '%%%s%%' or en.gene_name 
      LIKE '%%%s%%' or en.functional_name LIKE '%%%s%%') LIMIT %s" % 
      [escape_scientific_name, escape_term, escape_term, escape_term, limit.to_i])
  end

  def transcripts
    result = Set.new()
    external_matches.each do |em|
      result.add(em.transcript)
    end
    result
  end
  
  def table_items
    Seabase::Normalizer.new(Replicate.all(), transcripts, ExternalName.connection.select_rows("SELECT mc.mapping_count, mc.replicate_id, em.transcript_id
      FROM mapping_counts mc, external_matches em, external_names en
      WHERE em.transcript_id = mc.transcript_id
      AND em.external_name_id = en.id
      AND en.id = #{id}")).table
    end
end
