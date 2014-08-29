module Seabase
  # Describes transcript data
  class TranscriptContext
    attr_reader :replicate
    attr_reader :transcript
    attr_reader :mapping_count

    def initialize(replicate, transcript, mapping_count)
      @replicate = replicate
      @transcript = transcript
      @mapping_count = mapping_count
    end

    def length
      @transcript.length
    end
    
    def total_mapping
      @replicate.total_mapping
    end
    
    def y_intercept
      @replicate.y_intercept
    end
    
    def slope
      @replicate.slope
    end

    def set_lookup_hash
      [replicate.id, transcript.id, mapping_count]
    end
  end
end
