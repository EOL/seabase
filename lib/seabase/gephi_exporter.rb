module Seabase
  # Exports data from Seabase to Gephi-compatible format
  class GephiExporter
    def initialize(opts)
      @path_in = opts[:path_in]
      @path_out = opts[:path_out]
      @threshold = opts[:threshold]
      @builder = builder_factory(opts[:format])
      @existing_nodes = {}
    end

    def export
      @builder.start
      Seabase.logger.info("Exporting Similarity for Gephi")
      args = { col_sep: "\t" }
      csv_build(args)
      @builder.stop
    end

    private

    def csv_build(args)
      count = 0
      CSV.open(@path_in, args).each do |r|
        count += 1
        @builder.add_row(r) if (r[2].to_f > @threshold) && not_duplicate(r)
        if (count % 1_000_000).zero?
          Seabase.logger.info "Traversed line #{count}"
        end
      end
    end

    def not_duplicate(r)
      node = r[0..1].sort.join("-")
      if @existing_nodes.key?(node)
        false
      else
        @existing_nodes[node] = true
      end
    end

    def builder_factory(format)
      case format
      when "csv"
        Seabase::GephiCsvBuilder.new(@path_out)
      when "gexf"
        Seabase::GephiGexfBuilder.new(@path_out)
      else
        fail(Seabase::UnknownFormatError,
             "#{format} is unknown -- use 'csv' or 'gexf'")
      end
    end
  end
end
