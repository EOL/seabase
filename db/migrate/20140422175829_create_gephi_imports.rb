class CreateGephiImports < ActiveRecord::Migration
  def change
    create_table :gephi_imports do |t|
      t.string :name
    end
  end
end
