class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.text :description

      t.timestamps
    end
  end
end
