class CreateSetName < ActiveRecord::Migration
  def change
    create_table :set_names do |t|
      t.string :name
    end
  end
end
