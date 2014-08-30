module Seabase
  # Builds Gephi-compatible CSV file
  class GephiCsvBuilder
    def initialize(path_out)
      unless path_out[-4..-1] == ".csv"
        fail Seabase::FileExtensionError, "CSV file should end with .csv"
      end
      @path_out = path_out
      FileUtils.rm(@path_out) if File.exist?(@path_out)
    end

    def start
      @file = open(@path_out, "w:utf-8")
    end

    def stop
      @file.close
    end

    def add_row(ary)
      @file.write(format("%s;%s\n", *ary[0..1].map { |id| url_id(id) }))
    end

    private

    def url_id(id)
      "http://seabase.core.cli.mbl.edu/transcript/%s" % id
    end
  end
end
