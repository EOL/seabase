#!/usr/bin/env ruby
require 'optparse'
 
OPTS = {}
OptionParser.new do |o|
  o.on('-e ENVIRONMENT') { |env| OPTS[:environment] = env }
  o.on('-h') { puts o; exit }
  o.parse!
end

ENV['SEABASE_ENV'] = OPTS[:environment] || 'development'

require_relative '../lib/seabase'

class SimilarityCalc
  def initialize
    @db = Transcript.connection
    @db.execute('truncate expression_similarities')
    @transcript_ids = @db.select_values('select id from transcripts')
    @vectors = get_vectors
    @data = []
  end

  def calculate
    puts 'Calculating similarity'
    @transcript_ids.each do |t1|
      puts "Transcript %s" % t1
      @transcript_ids.each do |t2|
        next if t1 == t2
        @data << "(%s, %s, %s)" % [t1, t2, Seabase::CosineSimilarity.
                 calculate(@vectors[t1], @vectors[t2])]
        dump_data if t2 % 1000 == 0
      end
      dump_data
    end
  end

  private

  def dump_data
    return if @data.empty?
    @db.execute("
      insert into expression_similarities
      (transcript_id1, transcript_id2, score)
      values %s" % @data.join(','))
    @data = []
  end

  def get_vectors
    puts 'Collecting data'
    vectors = {} 
    @transcript_ids.each do |t|
      vector = @db.select_values("
        select sum(`count`) 
        from normalized_counts
        where transcript_id = %s
        group by stage order by stage" % t)
      vectors[t] = vector
      puts "Transcript %s" % t if t % 10000 == 0
    end
    vectors
  end
end

sc = SimilarityCalc.new
sc.calculate






