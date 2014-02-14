# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140214102955) do

  create_table "comments", force: true do |t|
    t.integer  "news_post_id"
    t.integer  "user_id"
    t.integer  "parent"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conditions", force: true do |t|
    t.text "description"
  end

  create_table "external_matches", force: true do |t|
    t.integer "transcript_id"
    t.integer "length"
    t.integer "query_from"
    t.integer "query_to"
    t.integer "paralog"
    t.integer "isoform"
    t.integer "external_name_id"
  end

  add_index "external_matches", ["external_name_id"], name: "index_external_matches_on_external_name_id", using: :btree
  add_index "external_matches", ["transcript_id"], name: "index_external_matches_on_transcript_id", using: :btree

  create_table "external_names", force: true do |t|
    t.integer "external_source_id"
    t.string  "name"
    t.integer "taxon_id"
    t.string  "gene_name"
    t.text    "functional_name"
  end

  add_index "external_names", ["external_source_id"], name: "index_external_names_on_external_source_id", using: :btree
  add_index "external_names", ["taxon_id"], name: "index_external_names_on_taxon_id", using: :btree

  create_table "external_sources", force: true do |t|
    t.string "name"
  end

  create_table "mapping_counts", force: true do |t|
    t.integer "replicate_id"
    t.integer "transcript_id"
    t.integer "mapping_count"
  end

  add_index "mapping_counts", ["replicate_id"], name: "index_mapping_counts_on_replicate_id", using: :btree
  add_index "mapping_counts", ["transcript_id", "replicate_id"], name: "idx_mapping_counts_03", unique: true, using: :btree
  add_index "mapping_counts", ["transcript_id"], name: "index_mapping_counts_on_transcript_id", using: :btree

  create_table "news_posts", force: true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",    default: false
  end

  create_table "replicates", force: true do |t|
    t.integer "taxon_id"
    t.string  "name"
    t.integer "stage"
    t.integer "condition_id"
    t.integer "technical_replicate"
    t.integer "lane_replicate"
    t.float   "y_intercept"
    t.float   "slope"
    t.integer "total_mapping"
  end

  add_index "replicates", ["condition_id"], name: "index_replicates_on_condition_id", using: :btree
  add_index "replicates", ["taxon_id"], name: "index_replicates_on_taxon_id", using: :btree

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "roles_users", force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], name: "idx_roles_users_1", unique: true, using: :btree

  create_table "set_names", force: true do |t|
    t.string "name"
  end

  create_table "taxons", force: true do |t|
    t.string "scientific_name"
    t.string "common_name"
  end

  create_table "time_units", force: true do |t|
    t.string "unit"
    t.string "abbreviation"
  end

  create_table "transcripts", force: true do |t|
    t.string  "name"
    t.integer "isogroup"
    t.integer "length"
    t.text    "transcript_sequence"
  end

  create_table "transcripts_data", force: true do |t|
    t.integer "transcript_id"
    t.integer "time_point"
    t.integer "time_unit_id"
    t.float   "quantity"
    t.boolean "averaged"
    t.integer "set_name_id_id"
  end

  add_index "transcripts_data", ["transcript_id"], name: "index_transcripts_data_on_transcript_id", using: :btree

  create_table "users", force: true do |t|
    t.string "email"
    t.string "name"
    t.string "password_hash"
    t.string "token"
  end

end
