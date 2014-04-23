class CreateTraces < ActiveRecord::Migration
  def change
    create_table :traces do |t|
      t.references :gephi_import, index: true
    end
  end
end
