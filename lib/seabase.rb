require_relative '../environment'
require_relative 'seabase/version'
require_relative 'seabase/normalizer'
require_relative 'seabase/blast_cgi'

class Seabase

  def self.maxup(num)
    digits = 10 ** Math.log10(num).floor
    (((num.to_f/digits).round(1) + 0.1) * digits).to_i
  end
  
end
