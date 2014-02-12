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
  path = File.join(settings.root, 'blast', 'blast.cgi')
  blast = Seabase::BlastCgi.new(env, path)
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
  @chart_title = "Transcripts homologous to %s" % @en.gene_name
  haml :external_name
end

get '/transcript/?:id?' do
  @tr = Transcript.find_by_name(params[:name]) if params[:name]
  @tr = Transcript.find(params[:id]) if params[:id]
  if params[:external_name_id]
    @en = ExternalName.find(params[:external_name_id])
  end
  @chart_title = "Transcript %s" % @tr.name
  @table_data = @tr.table_items.unshift(Replicate.all_stages)
  @name = "Transcript #{@tr.name}"
  haml :transcript
end

get '/test_charts' do
  data = []
  f = File.open(File.join(settings.root, 'technical_files', 'test_set'))
  max_y = 0
  f.each_with_index do |l, i|
    transcripts = Transcript.find_by_sql("
                                 select * 
                                 from transcripts 
                                 where name 
                                 like '%s%%'" % l.strip)
    transcripts.each do |tr|
      d = tr.table_items.unshift(Replicate.all_stages)
      d[-1][0] = tr.name
      data << d[0] if i == 0
      data << d[-1]
      new_max_y = d[-1][1..-1].max
      max_y = new_max_y if new_max_y > max_y
    end
  end
  @max_y = max_y
  @table_data = data 
  haml :test_charts
end

get '/test_d3' do
  haml :test_d3
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
