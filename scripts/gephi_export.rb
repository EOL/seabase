#!/usr/bin/env ruby
require 'optparse'
 
OPTS = {}
OptionParser.new do |o|
  o.on('-e ENVIRONMENT') { |env| OPTS[:environment] = env }
  o.on('-f FORMAT') { |format| OPTS[:format] = format }
  o.on('-t THRESHOLD') { |t| OPTS[:threshold] = t }
  o.on('-h') { puts o; exit }
  o.parse!
end

ENV['SEABASE_ENV'] = OPTS[:environment] || 'development'
FORMAT = OPTS[:format] || 'csv'
THRESHOLD = OPTS[:threshold] || '0.99'

require_relative '../lib/seabase'

Seabase.logger = Logger.new($stdout)

path_in = File.expand_path('../../java/similarities.tsv', __FILE__)
path_out = File.expand_path("../../tmp/seabase.%s" % FORMAT, __FILE__)
threshold = THRESHOLD.to_f
format = FORMAT

ge = Seabase::GephiExporter.new(path_in: path_in,
                           path_out: path_out,
                           threshold: threshold,
                           format: format)

ge.export
