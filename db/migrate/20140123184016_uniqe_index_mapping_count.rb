class UniqeIndexMappingCount < ActiveRecord::Migration
  def up
    add_index :mapping_counts, [:transcript_id, :replicate_id], unique: true,
      name: :idx_mapping_counts_03
  end
  
  def down
    remove_index :mappint_counts, name: :idx_mapping_counts_03
  end
end
