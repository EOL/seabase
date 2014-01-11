class CreateExternalMatches < ActiveRecord::Migration
  def change
    create_table :external_matches do |t|
      t.references :taxon, index: true
      t.references :external_identifier, index: true
      t.references :transcript, index: true
      t.string :gene_name
      t.text :functional_name
      t.integer :length
      t.integer :query_from
      t.integer :query_to
      t.integer :paralog
      t.integer :isoform

      t.timestamps
    end
  end
end
