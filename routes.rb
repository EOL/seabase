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
  blast = Seabase::BlastCgi.new(env)
  @cgi_blast = blast.run
  haml :blast_result
end

get '/search.?:format?' do
  opts = {
    format: params[:format],
    scientific_name: params[:scientific_name],
    term: params[:term],
    limit: (params[:batch_size] || 100),
    exact_search: (params[:exact_search] == 'true'),
    callback: params[:callback]
  }
  @external_names = perform_search(opts)
  format_search_results(opts)
end

get '/external_names/:id' do
  @en = ExternalName.find(params[:id])
  @table_data = @en.table_items.unshift(Replicate.all_stages)
  @chart_title = "Sum of transcription levels for %s homologs" % @en.gene_name
  haml :external_name
end

get '/transcript/?:id?' do
  @tr = Transcript.find_by_name(params[:name]) if params[:name]
  @tr = Transcript.find(params[:id]) if params[:id]
  if params[:external_name_id]
    @en = ExternalName.find(params[:external_name_id])
  end
  @chart_title = "Transcription levels for %s" % @tr.name
  @table_data = @tr.table_items.unshift(Replicate.all_stages)
  @name = "Transcript #{@tr.name}"
  haml :transcript
end

private

def perform_search(opts)
  if opts[:exact_search]
    opts[:term].gsub!(/:[^:]*:.*/, '')
    ExternalName.exact_search(opts)
  else
    ExternalName.like_search(opts)
  end
end

def format_search_json(opts)
  content_type 'application/json', charset: 'utf-8'
  names_json = @external_names.to_json
  if opts[:callback]
    names_json = "%s(%s)" % [opts[:callback], names_json]
  end
  names_json
end

def format_search_html(opts)
  if @external_names.size == 1
    redirect "/external_names/%s" % @external_names[0].id
  else
    @ortholog_name = Taxon.
      scientific_name_to_ortholog_name(opts[:scientific_name])
    @term = opts[:term]
    haml :search_result
  end
end

def format_search_results(opts)
  if opts[:format] == 'json'
    format_search_json(opts)
  else
    format_search_html(opts)
  end
end
