class CreateTranscripts < ActiveRecord::Migration
  def change
    create_table :transcripts do |t|
      t.string :name
      t.integer :isogroup
      t.integer :length
      t.text :transcript_sequence

      t.timestamps
    end
  end
end
