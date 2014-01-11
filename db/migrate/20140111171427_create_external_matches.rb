class CreateExternalMatches < ActiveRecord::Migration
  def change
    create_table :external_matches do |t|
      t.references :taxon, index: true
      t.references :external_identifier, index: true
      t.references :transcript, index: true
      t.string :gene_name
      t.text :functional_name
      t.int :length
      t.int :query_from
      t.int :query_to
      t.int :paralog
      t.int :isoform

      t.timestamps
    end
  end
end
