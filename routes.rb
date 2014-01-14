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
      @external_names = ExternalName.exact_search(scientific_name, term)
    else
      @external_names = ExternalName.like_search(scientific_name, term, limit)
    end
    if params[:format] == 'json'
      content_type 'application/json', charset: 'utf-8'
      names_json = @external_names.to_json
      if params[:callback]
        names_json = "%s(%s)" % [params[:callback], names_json]
      end
      names_json

    else
      if @external_names.size == 1
        redirect "/external_names/%s" % @external_names[0].id
      else
        haml :search_result
      end
    end
    
  end

  get '/external_names/:id' do
    @en = ExternalName.find(params[:id])
    @table_data = @en.table_items.unshift(Replicate.all_stages)
    haml :external_name
  end

  get '/transcript/:id' do
    @tr = Transcript.find(params[:id])
    @table_data = @tr.table_items.unshift(Replicate.all_stages)
    haml :transcript
  end

end

