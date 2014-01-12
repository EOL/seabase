class SeabaseApp < Sinatra::Base

  def seq_from_file(file)
    File.read(file[:tempfile].path)
  end

  get '/css/:filename.css' do
    scss :"sass/#{params[:filename]}"
  end

  get '/' do
    haml :home
  end

  get '/blast' do
    haml :blast
  end

  post '/blast' do
    program = params[:program]
    file = params[:seqfile]
    @seq = file ? seq_from_file(file) : params[:sequence]
    from_query = params[:from_query]
    to_query = params[:to_query]
    blast = Seabase::Blast.new(program)
    @blast_result = @seq.to_s != '' ? blast.search(@seq) : nil
    if @blast_result
      haml :blast_result
    else
      redirect '/blast' 
    end
  end

  get '/search.?:format?' do
    scientific_name = params[:scientific_name]
    # scientific_name = params[:organism] # Currently ignored
    term = params[:term]
    limit = params[:batch_size] || 100
    exact_search = params[:exact_search] == 'true'
    if exact_search
      @external_identifiers = ExternalMatch.exact_ei_search(scientific_name, term)
    else
      @external_identifiers = ExternalMatch.like_ei_search(scientific_name,
                                                           term, limit)
    end
    if params[:format] == 'json'
      content_type 'application/json', charset: 'utf-8'
      names = @external_identifiers.map { |n| { name: n } }
      names_json = names.to_json
      if params[:callback]
        names_json = "%s(%s)" % [params[:callback], names_json]
      end
      names_json

    else
      haml :search_result
    end
    
  end

end

