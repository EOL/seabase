class CreateTranscriptsTimePoints < ActiveRecord::Migration
  def change
    create_table :transcripts_data do |t|
      t.references :transcript, index: true
      t.integer    :time
      t.references :time_unit
      t.float      :quantity
      t.boolean    :averaged
      t.string     :name
    end
  end
end
