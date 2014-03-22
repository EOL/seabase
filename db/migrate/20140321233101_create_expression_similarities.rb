class CreateExpressionSimilarities < ActiveRecord::Migration
  def change
    create_table :expression_similarities do |t|
      t.integer  :transcript_id1, index: true, null: false
      t.integer  :transcript_id2, index: true, null: false
      t.float    :score
    end
  end
end
