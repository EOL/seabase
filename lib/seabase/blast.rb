class Seabase
  class Blast
    attr_reader :command
    attr_reader :database
    attr_reader :blast


    def initialize(command, database = 'nematostella_vectensis_transcriptome')
      @command = command
      @database = database
      @blast = Bio::Blast.local(@command,database_path)
    end

    def database_path
      path = File.expand_path(File.join('..', '..', '..',
                                        'blast', 'db', 
                                        database, database), __FILE__) 
    end

    def sequence(sequence_string)
      sequence_string
    end

    def search(sequence_string)
      seq = sequence(sequence_string) 
      @blast.query(seq)
    end
    
  end
end
