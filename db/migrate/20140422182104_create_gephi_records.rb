class CreateGephiRecords < ActiveRecord::Migration
  def change
    create_table :gephi_records do |t|
      t.references :gephi_import
      t.integer :transcript_id
      t.integer :modularity
      t.float :page_rank
    end
  end
end
