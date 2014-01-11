class CreateMappingCounts < ActiveRecord::Migration
  def change
    create_table :mapping_counts do |t|
      t.references :replicate, index: true
      t.references :transcript, index: true
      t.integer :mapping_count

      t.timestamps
    end
  end
end
