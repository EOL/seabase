class CreateExternalNamesIndex < ActiveRecord::Migration
  def change
    add_index "external_matches", ["external_name_id"], name: "index_external_matches_on_external_name_id", using: :btree
  end
end
