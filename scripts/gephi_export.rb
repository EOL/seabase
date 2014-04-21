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

path = File.expand_path('../../java', __FILE__)

Dir.entries(path).select { |f| f.match(/similarities_\d.tsv/) }.each do |file|
  Seabase.logger.info("Generating %s for %s" % [FORMAT, file])
  path_in = File.join(path, file)
  file_out = file.gsub('tsv', FORMAT)
  path_out = File.expand_path("../../tmp/%s" % file_out, __FILE__)
  threshold = THRESHOLD.to_f
  format = FORMAT

  ge = Seabase::GephiExporter.new(path_in: path_in,
                             path_out: path_out,
                             threshold: threshold,
                             format: format)

  ge.export
end
