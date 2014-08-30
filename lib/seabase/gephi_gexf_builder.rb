module Seabase
  # Creates XML compatible with Gephi format
  class GephiGexfBuilder
    attr_reader :doc

    def initialize(path_out)
      unless path_out[-5..-1] == ".gexf"
        fail Seabase::FileExtensionError, "GEXF file should end with .gexf"
      end
      @path_out = path_out
      @edge_count = 0
      FileUtils.rm(@path_out) if File.exist?(@path_out)
    end

    def start
      @doc = Nokogiri::XML template
      @nodes = @doc.at_xpath("//xmlns:nodes")
      @edges = @doc.at_xpath("//xmlns:edges")
    end

    def add_row(row)
      [Transcript.find(row[0]), Transcript.find(row[1])].each do |t|
        node = Nokogiri::XML::Node.new("node", @doc)
        node["id"] = t.id
        node["label"] = t.name
        node.parent = @nodes
      end
      edge = Nokogiri::XML::Node.new("edge", @doc)
      add_edge(edge, row)
    end

    def stop
      Seabase.logger.info "Saving xml to a #{@path_out}"
      File.open(@path_out, "w:utf-8") { |f| f.write @doc.to_xml }
    end

    def template
      %q(<?xml version="1.0" encoding="UTF-8"?>
  <gexf xmlns="http://www.gexf.net/1.2draft" version="1.2">
      <graph mode="static" defaultedgetype="undirected">
          <nodes>
          </nodes>
          <edges>
          </edges>
      </graph>
  </gexf>)
    end

    private

    def add_edge(edge, row)
      edge["id"] = @edge_count
      @edge_count += 1
      edge["source"] = row[0]
      edge["target"] = row[1]
      edge.parent = @edges
    end
  end
end
