require 'set'

class Seabase

  class SetLookup

    def initialize; @set_hash = {}; @contexts = Set.new; end
    def [](index); @set_hash[index]; end
    def keys; @set_hash.keys; end
    
    def add(index, value)
      if @set_hash.member?(index)
        unless has_context?(value)
          @set_hash[index].add(value)
          add_context(value)
        end
      else
        @set_hash[index] = Set.new([value])
      end
    end
    
    # It's not clear if this is still necessary, but logically it doesn't hurt.
    def has_context?(value)
      (value.class == TranscriptContext) && 
        @contexts.member?(value.set_lookup_hash)
    end
    
    def add_context(value)
      @contexts.add(value.set_lookup_hash) if (value.class == TranscriptContext)
    end
  end
  
  class TranscriptContext
    attr_reader :replicate
    attr_reader :transcript
    attr_reader :mapping_count
        
    def initialize(replicate, transcript, mapping_count)
      @replicate = replicate
      @transcript = transcript
      @mapping_count = mapping_count
    end

    def length; @transcript.length; end
    def total_mapping; @replicate.total_mapping; end
    def y_intercept; @replicate.y_intercept; end
    def slope; @replicate.slope; end
    def set_lookup_hash; [replicate.id, transcript.id, mapping_count]; end
  end
  
  class Normalizer

    def initialize(replicates, transcripts, mapping_count_data)
      @replicates = id_to_obj_hash(replicates)
      @transcripts = id_to_obj_hash(transcripts)
      @data = mapping_count_data
      
      @distinct_technical_replicates = Set.new
      @technical_replicates = SetLookup.new
      @lane_replicates = SetLookup.new
      @replicate_transcripts = SetLookup.new
      
      process_data
      
      @stage_to_replicate = SetLookup.new
      replicates.each {|r| @stage_to_replicate.add(r.stage, r)}
    end

    def id_to_obj_hash(objs)
      result = {}
      objs.each do |o|
        result[o.id] = o
      end
      result
    end
    
    def process_data
      @data.each do |mapping_count, replicate_id, transcript_id|
        replicate = @replicates[replicate_id]
        transcript = @transcripts[transcript_id]
        @distinct_technical_replicates.add(replicate.technical_replicate)
        @technical_replicates.add(replicate.stage, 
                                  replicate.technical_replicate)
        @lane_replicates.add([replicate.stage, 
                             replicate.technical_replicate], 
                             replicate.lane_replicate)
        @replicate_transcripts.add([replicate.stage, 
                                   replicate.technical_replicate, 
                                   replicate.lane_replicate], 
                                   TranscriptContext.new(replicate, 
                                                         transcript, 
                                                         mapping_count))
      end
    end
    
    def technical_replicates(stage); @technical_replicates[stage] || []; end
    def lane_replicates(stage, tr); @lane_replicates[[stage, tr]];end

    def replicate_transcripts(stage, tr, lr)
      @replicate_transcripts[[stage, tr, lr]]
    end
    
    def count_per_embryo(stage, technical_replicate)
      if technical_replicate
        technical_replicate_counts(stage, technical_replicate)
      else
        average_ignore_zeros(technical_replicates(stage).
                             map {|tr| technical_replicate_counts(stage, tr)})
      end
    end

    def average_ignore_zeros(nums)
      count = 0.0
      total = 0
      nums.each do |n|
        if n != 0
          count += 1
          total += n
        end
      end
      count == 0 ? 0 : total/count
    end
    
    def technical_replicate_counts(stage, technical_replicate)
      lrs = lane_replicates(stage, technical_replicate)
      lrs ? average_ignore_zeros(lrs.map { |lr| lane_replicate_counts(stage, 
                                                technical_replicate, lr) }) : nil
    end
    
    def lane_replicate_counts(stage, technical_replicate, lane_replicate)
      watching = (stage == 1) and (technical_replicate == 1)
      rts = replicate_transcripts(stage, technical_replicate, lane_replicate)
      total = 0
      if rts
        rts.each do |lane_context|
          total += normalize_rpkm(fpkm(lane_context.length, 
                                       lane_context.mapping_count, 
                                       lane_context.total_mapping), 
                                  lane_context.y_intercept, 
                                  lane_context.slope)
        end
      end
      total
    end
    
    def fpkm(length, mapping_count, total_mapping)
      (mapping_count * 1e9) / (length * total_mapping.to_f)
    end
    
    NUMBER_OF_EMBRYOS = 150
    
    def normalize_rpkm(fpkm, y_intercept, slope)
      ((fpkm * slope + y_intercept) / NUMBER_OF_EMBRYOS) / 10
    end
    
    START_OF_ALPHABET = 64
    
    def row(technical_replicate)
      result = stages.map {|s| count_per_embryo(s, technical_replicate)}
      result.unshift(technical_replicate ? 
                     (technical_replicate + START_OF_ALPHABET).chr : 
                     'Average')
    end
    
    def table(technical_replicate=nil)
      (technical_replicate ? [] : 
       @distinct_technical_replicates.sort.
         map {|tr| row(tr)}).push(row(technical_replicate))
    end
    
    def stages; @stage_to_replicate.keys.sort; end
  end
end
