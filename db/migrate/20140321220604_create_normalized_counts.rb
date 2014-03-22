class CreateNormalizedCounts < ActiveRecord::Migration
  def change
    create_table :normalized_counts do |t|
      t.references :transcript, index: true, null: false
      t.integer :stage
      t.integer :technical_replicate
      t.float   :count
    end
  end
end
