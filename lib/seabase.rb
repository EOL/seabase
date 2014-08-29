require_relative "../environment"
require_relative "seabase/errors"
require_relative "seabase/version"
require_relative "seabase/set_lookup"
require_relative "seabase/transcript_context"
require_relative "seabase/normalizer"
require_relative "seabase/blast_cgi"
require_relative "seabase/cosine_similarity"
require_relative "seabase/gephi_exporter"
require_relative "seabase/gephi_csv_builder"
require_relative "seabase/gephi_gexf_builder"

# All-encompassing module of the project
module Seabase
  def self.maxup(num)
    digits = 10 ** Math.log10(num).floor
    (((num.to_f/digits).round(1) + 0.1) * digits).to_i
  end

  def self.logger
    @logger ||= Logger.new("/dev/null")
  end

  def self.logger=(new_logger)
    @logger = new_logger
  end
end
