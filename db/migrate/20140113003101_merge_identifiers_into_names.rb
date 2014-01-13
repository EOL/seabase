class MergeIdentifiersIntoNames < ActiveRecord::Migration
  def up
    create_table :external_names_tmp do |t|
      t.integer :external_source_id
      t.string :name
      t.integer :taxon_id
      t.string :gene_name
      t.text :functional_name

      t.timestamps
    end
    
    execute("INSERT INTO external_names_tmp
    SELECT en.id, ei.external_source_id, ei.name, en.taxon_id, en.gene_name, en.functional_name, en.created_at, en.updated_at
    FROM external_names en, external_identifiers ei
    WHERE ei.id = en.external_identifier_id")
    
    drop_table :external_names
    drop_table :external_identifiers
    rename_table :external_names_tmp, :external_names
    
    add_index "external_names", ["external_source_id"], name: "index_external_names_on_external_source_id", using: :btree
    add_index "external_names", ["taxon_id"], name: "index_external_names_on_taxon_id", using: :btree
    
  end
end
