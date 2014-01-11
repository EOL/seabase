class Seabase
  class Blast
    attr_reader :command
    attr_reader :database


    def initialize(command, database)
      @command = command
      @database = database
      @blast = Bio::Blast.local(@command,database_path)
    end

    def database_path
      path = File.expand_path(File.join('..', '..', '..',
                                        'blast', 'db', database), __FILE__) 
    end

    def sequence(sequence_string)
      Bio::Sequence.auto(sequence_string)
    end

    def search(sequence_string)
      seq = sequence(sequence_string) 
      @blast.query(seq)
    end
    
  end
end
