class CreateReplicates < ActiveRecord::Migration
  def change
    create_table :replicates do |t|
      t.references :taxon, index: true
      t.string :name
      t.integer :stage
      t.references :condition, index: true
      t.integer :technical_replicate
      t.integer :lane_replicate
      t.float :y_intercept
      t.float :slope
      t.integer :total_mapping

      t.timestamps
    end
  end
end
