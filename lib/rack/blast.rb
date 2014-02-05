class Rack::Blast

  def initialize(app)
    @app = app
    @cgi_file = 'blast.cgi'
  end

  def call(env)
    status, headers, response = @app.call(env)
    if env['REQUEST_URI'] =~ %r#(/blast|\.cgi)$# && 
         env['REQUEST_METHOD'].downcase == 'post'
      @cgi_file = 'nph-viewgif.cgi' if env['REQUEST_URI'] =~ /\.cgi$/
      cgi_response = run_blast(env)
      cgi_text = fix_cgi_response(cgi_response)
      response[0].gsub!('###CGI_BLAST_RESULT###', cgi_text)
      headers['Content-Length'] = response[0].size.to_s
    end
    [status, headers, response] 
  end

  private

  def fix_cgi_response(text)
    text.gsub!(%r|.*?(<pre>.*</pre>).*|mi, '\1')
    text.gsub!(/nph-viewgif.cgi\?/, '/TmpGifs/')
    text.gsub!(%r|"\.\./blast/|, '"/')
    text.gsub!(%r#^(><a name = [\d]+></a>|\s*)(NVT-)(\S+)(\s.+)$#, '\1<a href="/transcript?name=\3">\2\3</a>\4')
    text
  end

  def get_path
    return @blast_path if @blast_path
    path = File.join("../../../blast/%s" % @cgi_file)
    @blast_path = File.expand_path(path, __FILE__)
  end

  def run_blast(env)
    cgi = ChildProcess.build(get_path)
    cgi.duplex = true
    cgi.cwd = File.dirname(get_path)
    
    cgi_out, cgi.io.stdout = IO.pipe
    cgi.io.stderr = $stderr

    cgi.environment['DOCUMENT_ROOT'] = 'public'
    cgi.environment['SERVER_SOFTWARE'] = 'Rack Blast'
    env.each do |key, value|
      cgi.environment[key] = value if
        value.respond_to?(:to_str) && key =~ /^[A-Z_]+$/
    end
    
    cgi.start

    cgi.io.stdin.write env['rack.input'].read if env['rack.input']
    cgi.io.stdout.close

    headers = {}
    until cgi_out.eof? || (line = cgi_out.readline.chomp) == ''
      if line =~ /\s*\:\s*/
        key, value = line.split /\s*\:\s*/, 2
        if headers.has_key? key
          headers[key] += "\n" + value
        else
          headers[key] = value
        end
      end
    end

    status = (headers.delete('Status') || 200).to_i

    raise Rack::Blast::ExecutionError if cgi.crashed?

    cgi_out.read
  end

end

class Rack::Blast::ExecutionError < StandardError
end


__END__
  # Will run the given path with the given environment
  def run env, path
    # Setup CGI process
    cgi = ChildProcess.build path
    cgi.duplex = true
    cgi.cwd = File.dirname path

    # Arrange CGI processes IO
    cgi_out, cgi.io.stdout = IO.pipe
    cgi.io.stderr = $stderr

    # Config CGI environment
    cgi.environment['DOCUMENT_ROOT'] = @public_dir
    cgi.environment['SERVER_SOFTWARE'] = 'Rack Legacy'
    env.each do |key, value|
      cgi.environment[key] = value if
        value.respond_to?(:to_str) && key =~ /^[A-Z_]+$/
    end

    # Start running CGI
    cgi.start

    # Delegate IO to CGI process
    cgi.io.stdin.write env['rack.input'].read if env['rack.input']
    cgi.io.stdout.close

    # Extract headers from output
    headers = {}
    until cgi_out.eof? || (line = cgi_out.readline.chomp) == ''
      if line =~ /\s*\:\s*/
        key, value = line.split /\s*\:\s*/, 2
        if headers.has_key? key
          headers[key] += "\n" + value
        else
          headers[key] = value
        end
      end
    end

    # Extract status from sub-process, default to 200
    status = (headers.delete('Status') || 200).to_i

    # Throw error if process crashed.
    # NOTE: Process could still be running and crash later. This just
    #       ensure we response correctly if it immmediately crashes
    raise Rack::Legacy::ExecutionError if cgi.crashed?

    # Send status, headers and remaining IO back to rack
    [status, headers, cgi_out]
  end
