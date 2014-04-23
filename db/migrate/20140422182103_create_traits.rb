class CreateTraits < ActiveRecord::Migration
  def change
    create_table :traits do |t|
      t.references :gephi_import, index: true
    end
  end
end
