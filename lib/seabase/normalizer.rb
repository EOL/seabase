require 'set'

# SELECT rs.stage, rs.technical_replicate, rs.lane_replicate, em.transcript_id, mc.mapping_count, rs.y_intercept, rs.slope, rs.total_mapping, tr.length
#   FROM replicates rs, mapping_counts mc, external_matches em, external_names en
#   WHERE rs.id = mc.replicate_id
#   AND em.transcript_id = mc.transcript_id
#   AND em.external_name_id = en.id
#   AND en.id = #{id}
#   ORDER BY rs.stage, rs.technical_replicate, rs.lane_replicate, em.transcript_id
  
class Seabase
  class SetLookup
    def initialize; @set_hash = {}; end
    def [](index); @set_hash[index]; end
    def keys; @set_hash.keys; end
    
    def add(index, value)
      if @set_hash.member?(index)
        @set_hash[index].add(value)
      else
        @set_hash[index] = Set.new([value])
      end
    end
  end
  
  class LaneContext
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
  end
  
  class Normalizer

    def initialize(replicates, transcripts, mapping_count_data)
      @replicates = id_to_obj_hash(replicates)
      @transcripts = id_to_obj_hash(transcripts)
      @data = mapping_count_data
      
      @technical_replicates = SetLookup.new
      @lane_replicates = SetLookup.new
      
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
        @technical_replicates.add(replicate.stage, replicate.technical_replicate)
        @lane_replicates.add([replicate.stage, replicate.technical_replicate], LaneContext(replicate, transcript, mapping_count))
      end
    end
    
    def technical_replicates(stage); @technical_replicates[stage]; end
    def lane_replicates(stage, tr); @lane_replicates[[stage, tr]];end
    
    def count_per_embryo(stage, technical_replicate=nil) # e.g. count_per_embryo(1, 1)
      if technical_replicate
        technical_replicate_counts(stage, technical_replicate)
      else
        all_trs = technical_replicates(stage)
        all_trs.inject {|sum, tr| sum + technical_replicate_counts(stage, tr)} / all_trs.size
      end
    end
    
    def technical_replicate_counts(stage, technical_replicate)
      total = 0
      lrs = lane_replicates(stage, technical_replicate)
      if lrs
        require 'ruby-debug'; debugger
        lrs.each do |lane_context|
          total += normalize_rpkm(fpkm(lane_context[1].length, lane_context[2], lane_context[0].total_mapping), lane_context[0].y_intercept, lane_context[0].slope)
        end
      end
      total
    end
    
    def fpkm(length, mapping_count, total_mapping)
      (mapping_count * 1e9) / (length * total_mapping.to_f)
    end
    
    def normalize_rpkm(fpkm, y_intercept, slope)
      ((fpkm * slope + y_intercept) / 300) / 0.1 # Should be 10
    end
    
    def table
      [stages.map {|s| count_per_embryo(s, 2)}]
    end
    
    def stages
      @stage_to_replicate.keys.sort
    end
  end
end
