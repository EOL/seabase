#!/usr/bin/env ruby
require 'optparse'
 
OPTS = {}
OptionParser.new do |o|
  o.on('-n') { |bool| OPTS[:new] = bool }
  o.on('-e ENVIRONMENT') { |env| OPTS[:environment] = env }
  o.on('-h') { puts o; exit }
  o.parse!
end

ENV['SEABASE_ENV'] = OPTS[:environment] || 'development'

require_relative '../lib/seabase'

db = Transcript.connection

db.execute('truncate table transcripts_data')

count = 0
Transcript.all.each do |t|
  count += 1
  puts "Processing transcript %s" % count if count % 100 == 0 
  ti = t.table_items
  hours = Replicate.all_stages
  data = []
  hours.each_with_index do |h, i|
    next if i == 0
    [0,1,2].each do |ii|
      is_average = ii == 2 ? 1 : 0
      quantity = ti[ii][i].is_a?(Numeric) ? ti[ii][i] : 'null'
      data << [t.id, h, 1, quantity, is_average, ("'%s'" % ti[ii][0])].
        join(',')
    end
  end
  data = "(%s)" % data.join('),(')
  db.execute("
    insert into transcripts_data 
    (transcript_id, time, time_unit_id, quantity, averaged, name)
    values
    %s" % data)
end


