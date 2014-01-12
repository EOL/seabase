class CreateExternalNames < ActiveRecord::Migration
  def change
    create_table :external_names do |t|
      t.references :taxon, index: true
      t.references :external_identifier, index: true
      t.string :gene_name
      t.text :functional_name

      t.timestamps
    end
    remove_column :external_matches, :taxon_id
    remove_column :external_matches, :external_identifier_id
    remove_column :external_matches, :gene_name
    remove_column :external_matches, :functional_name
    add_column :external_matches, :external_name_id, :integer
  end
end
