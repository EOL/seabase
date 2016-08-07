#!/usr/bin/env ruby

require_relative "../lib/seabase"
data = []
File.open('test_set').each do |l|
  transcripts = Transcript.find_by_sql("
                               select *
                               from transcripts
                               where name
                               like '%s%%'" % l.strip)
  transcripts.each do |tr|
    d = tr.table_items.unshift(Replicate.all_stages)
    data << [d[0], d[-1]]
  end
end
