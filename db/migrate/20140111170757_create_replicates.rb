class CreateReplicates < ActiveRecord::Migration
  def change
    create_table :replicates do |t|
      t.references :taxon, index: true
      t.string :name
      t.int :stage
      t.references :condition, index: true
      t.int :technical_replicate
      t.int :lane_replicate
      t.float :y_intercept
      t.float :slope
      t.int :total_mapping

      t.timestamps
    end
  end
end
