class GephiImport < ActiveRecord::Base
  has_many :gephi_records

  def self.process_file(file_path, name)
    res = []
    gi = self.create(name: name)
    data = {}
    CSV.open(file_path, headers: true).each do |row|
      trait = row['Modularity Class']
      transcript_id = row['Id'].split('/').last
      record = { transcript_id: transcript_id, page_rank: row['PageRank'] }
      if data.has_key?(trait)
        data[trait] << record
      else
        data[trait] = [record]
      end
    end
    process_data(data, gi)
    gi
  end

  private

  def self.process_data(data, gephi_import)
    data.each do |trait, records|
      if trait
        trait = Trait.create(gephi_import: gephi_import)
      end
      records.each do |record|
        GephiRecord.create(trait: trait,
                         transcript_id: record[:transcript_id],
                         page_rank: record[:page_rank])
      end
    end
  end

end
