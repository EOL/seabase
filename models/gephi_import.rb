class GephiImport < ActiveRecord::Base
  has_many :gephi_records

  def self.process_file(file_path, name)
    res = []
    gi = self.create(name: name)
    CSV.open(file_path, headers: true).each do |row|
      unless row['Modularity'] || row['PageRank']
        raise GephiImportError.new('Import does not have required fields: '\
                                   'Modularity or PageRank')
      end
      GephiRecord.create(gephi_import_id: gi.id, 
                         modularity: row['Modularity'],
                         page_rank: row['PageRank'])
    end
  end
end
