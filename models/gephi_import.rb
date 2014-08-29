# Imports data in Gephi formats
class GephiImport < ActiveRecord::Base
  has_many :traces

  def self.process_file(file_path, name)
    gi = create(name: name)
    data = {}
    CSV.open(file_path, headers: true).each do |row|
      trace = row["Modularity Class"]
      transcript_id = row["Id"].split("/").last
      record = { transcript_id: transcript_id, page_rank: row["PageRank"] }
      data.key?(trace) ? data[trace] << record : data[trace] = [record]
    end
    process_data(data, gi)
    gi
  end

  def self.process_data(data, gephi_import)
    data.each do |trace, records|
      trace &&= Trace.create(gephi_import: gephi_import)
      records.each do |record|
        GephiRecord.create(
          trace: trace, transcript_id: record[:transcript_id],
          page_rank: record[:page_rank]
        )
      end
    end
  end
end
