class Seabase::GephiExporter
  
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
    graph = open(@path_out, 'w:utf-8')
    count = 0
    CSV.open(@path_in, args).each do |r|
      count += 1
      if (r[2].to_f > @threshold) && not_duplicate(r)
        r[0] = url_id r[0]
        r[1] = url_id r[1]
        @builder.add_row(r)
      end
      if count % 1_000_000 == 0
        Seabase.logger.info "Traversed line %s" % count
      end
    end
    @builder.stop
  end

  private

  def url_id(id)
    "http://seabase.core.cli.mbl.edu/transcript/%s" % id
  end
  
  def not_duplicate(r)
    node = r[0..1].sort.join('-')
    if @existing_nodes.has_key?(node)
      false
    else
      @existing_nodes[node] = true
    end
  end

  def builder_factory(format)
    case format
    when 'csv'
      Seabase::GephiCsvBuilder.new(@path_out)
    when 'gexf'
      Seabase::GephiGexfBuilder.new(@path_out)
    else
      raise Seabase::UnknownFormatError.
        new("%s is unknown use 'csv' or 'gexf'")
    end
  end

end
