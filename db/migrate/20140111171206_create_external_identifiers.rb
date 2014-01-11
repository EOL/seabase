class CreateExternalIdentifiers < ActiveRecord::Migration
  def change
    create_table :external_identifiers do |t|
      t.references :external_source, index: true
      t.string :name

      t.timestamps
    end
  end
end
