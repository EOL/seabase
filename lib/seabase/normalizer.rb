module Seabase
  # Normalizes experiment data to number or molecules per embryo
  class Normalizer
    NUMBER_OF_EMBRYOS = 150
    START_OF_ALPHABET = 64

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
      replicates.each { |r| @stage_to_replicate.add(r.stage, r) }
    end

    def id_to_obj_hash(objs)
      objs.each_with_object({}) { |o, h| h[o.id] = o }
    end

    def process_data
      @data.each do |mapping_count, replicate_id, transcript_id|
        replicate = @replicates[replicate_id]
        transcript = @transcripts[transcript_id]
        populate_sets(replicate, transcript, mapping_count)
      end
    end

    def populate_sets(r, t, m)
      @distinct_technical_replicates.add(r.technical_replicate)
      @technical_replicates.add(r.stage, r.technical_replicate)
      @lane_replicates.add([r.stage, r.technical_replicate], r.lane_replicate)
      @replicate_transcripts.add(
        [r.stage, r.technical_replicate, r.lane_replicate],
        TranscriptContext.new(r, t, m)
      )
    end

    def technical_replicates(stage)
      @technical_replicates[stage] || []
    end

    def lane_replicates(stage, tr)
      @lane_replicates[[stage, tr]]
    end

    def replicate_transcripts(stage, tr, lr)
      @replicate_transcripts[[stage, tr, lr]]
    end

    def count_per_embryo(stage, technical_replicate)
      if technical_replicate
        technical_replicate_counts(stage, technical_replicate)
      else
        average_ignore_zeros(
          technical_replicates(stage).
            map { |tr| technical_replicate_counts(stage, tr) }
        )
      end
    end

    def average_ignore_zeros(nums)
      count = 0.0
      total = nums.reduce(0) do |res, n|
        count += 1 unless n.zero?
        res + n
      end
      count.zero? ? count : total / count
    end

    def technical_replicate_counts(stage, technical_replicate)
      lrs = lane_replicates(stage, technical_replicate)
      lrs && average_ignore_zeros(
        lrs.map { |lr| lane_replicate_counts(stage, technical_replicate, lr) }
      )
    end

    def lane_replicate_counts(stage, technical_replicate, lane_replicate)
      rts = replicate_transcripts(stage, technical_replicate, lane_replicate)
      Array(rts).reduce(0) do |total, lane_context|
        total + normalize_rpkm(
          fpkm(lane_context.length, lane_context.mapping_count,
               lane_context.total_mapping),
          lane_context.y_intercept,
          lane_context.slope
        )
      end
    end

    def fpkm(length, mapping_count, total_mapping)
      (mapping_count * 1e9) / (length * total_mapping.to_f)
    end

    def normalize_rpkm(fpkm, y_intercept, slope)
      ((fpkm * slope + y_intercept) / NUMBER_OF_EMBRYOS) / 10
    end

    def row(technical_replicate)
      result = stages.map { |s| count_per_embryo(s, technical_replicate) }
      row_name = "Average"
      row_name = (technical_replicate +
                  START_OF_ALPHABET).chr if technical_replicate
      result.unshift(row_name)
    end

    def table(technical_replicate = nil)
      (technical_replicate ? [] :
       @distinct_technical_replicates.sort.
         map { |tr| row(tr) }).push(row(technical_replicate))
    end

    def stages
      @stage_to_replicate.keys.sort
    end
  end
end
