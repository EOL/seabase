class CreateExternalSources < ActiveRecord::Migration
  def change
    create_table :external_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
