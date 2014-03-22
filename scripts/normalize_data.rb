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

db = Transcript.connection

db.execute 'truncate table normalized_counts'

transcripts = Transcript.all

technical_replicates = { "A" => 1, "B" => 2 }

count = 0
transcripts.each do |t|
  count += 1
  data = []
  t.table_items[0..1].each do |ary|
    technical_replicate = technical_replicates[ary.shift]
    ary.each_with_index do |n, i|
      n = 'null' unless n
      data << "(%s, %s, %s, %s)" % [t.id, i, technical_replicate, n] 
    end
  end
  data = data.join(",")
  db.execute("
    insert into normalized_counts
      (transcript_id, stage, technical_replicate, count)
      values %s" % data)
  puts "Transcript %s" % count if count % 100 == 0
end
