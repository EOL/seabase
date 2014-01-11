class CreateTranscripts < ActiveRecord::Migration
  def change
    create_table :transcripts do |t|
      t.string :name
      t.int :isogroup
      t.int :length
      t.text :transcript_sequence

      t.timestamps
    end
  end
end
