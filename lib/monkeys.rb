module Bio
  class Blast
    def make_command_line                                                        
      legacy = 'legacy_blast'
      legacy << '.pl' if os != 'linux'
      cmd = make_command_line_options                                            
      cmd.unshift 'blastall'
      cmd.unshift legacy
      cmd                                                                        
    end                                                                          
    
    private 

    def os
      os = 'linux'
      os = 'win' if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM)
      os = 'mac' if (/darwin/ =~ RUBY_PLATFORM) 
      os
    end
  end

end
