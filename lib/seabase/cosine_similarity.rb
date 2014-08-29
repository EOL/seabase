# Implementation of cosine similarity algorithm
module Seabase::CosineSimilarity
  def self.calculate(a, b)
    a = prepare_vector(a)
    b = prepare_vector(b)
    prod = dot_product(a, b)
    len1 = Math.sqrt(dot_product(a, a))
    len2 = Math.sqrt(dot_product(b, b))
    cosine = prod / (len1 * len2)
    cosine.round(3)
  end

  class << self
    private

    def dot_product(a, b)
      a.zip(b).map { |d| d[0] * d[1] }.inject { |s, i| s + i }
    end

    def prepare_vector(v)
      v.map { |v| v ? v : 0 }
    end
  end
end
