class Seabase::BlastCgi
  def initialize(env)
    @env = env
    @path = get_path
  end

  def run
    cgi, cgi_out = setup_cgi
    cgi_execute(cgi)
    body = cgi_out.read
    adjust_body(body)
  end

  private
  
  def adjust_body(text)
    text.gsub!(%r|.*?(<pre>.*</pre>).*|mi, '\1')
    text.gsub!(/nph-viewgif.cgi\?/, '/TmpGifs/')
    text.gsub!(%r|"\.\./blast/|, '"/')
    text.gsub!(%r#^(><a name = [\d]+></a>|\s*)(NVT-)(\S+)(\s.+)$#, 
               '\1<a href="/transcript?name=\3">\2\3</a>\4')
    text
  end

  def get_path
    path = File.join("../../../blast/%s" % 'blast.cgi')
    File.expand_path(path, __FILE__)
  end

  def setup_cgi
    cgi = ChildProcess.build(@path)
    cgi.duplex = true
    cgi.cwd = File.dirname(@path)
    
    cgi_out, cgi.io.stdout = IO.pipe
    cgi.io.stderr = $stderr
    set_cgi_environment(cgi)
    [cgi, cgi_out]
  end

  def set_cgi_environment(cgi)
    cgi.environment['DOCUMENT_ROOT'] = 'public'
    cgi.environment['SERVER_SOFTWARE'] = 'CGI Blast'
    @env.each do |key, value|
      cgi.environment[key] = value if
        value.respond_to?(:to_str) && key =~ /^[A-Z_]+$/
    end
  end

  def cgi_execute(cgi)
    cgi.start
    cgi.io.stdin.write @env['rack.input'].read
    cgi.io.stdout.close
    raise Seabase::ExecutionError if cgi.crashed?
  end

end
