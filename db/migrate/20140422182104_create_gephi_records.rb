class CreateGephiRecords < ActiveRecord::Migration
  def change
    create_table :gephi_records do |t|
      t.references :trace
      t.integer :transcript_id
      t.float :page_rank
    end
  end
end
