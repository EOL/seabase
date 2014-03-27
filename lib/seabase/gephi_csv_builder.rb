class Seabase::GephiCsvBuilder

  def initialize(path_out)
    unless path_out[-4..-1] == '.csv'
      raise Seabase::FileExtensionError.new('CSV file should end with .csv')
    end
    @path_out = path_out
    FileUtils.rm(@path_out) if File.exists?(@path_out)
  end

  def start
    @file = open(@path_out, 'w:utf-8')
  end

  def stop
    @file.close
  end

  def add_row(ary)
    @file.write("%s;%s\n" % ary[0..1])
  end

end
