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

  def perform_search(opts)
    if opts[:exact_search]
      opts[:term].gsub!(/:[^:]*:.*/, '')
      ExternalName.exact_search(opts)
    else
      ExternalName.like_search(opts)
    end
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
    @name = "Protein #{@en.name}"
    haml :external_name
  end

  get '/transcript/:id' do
    @en = ExternalName.find(params[:external_name_id])
    @tr = Transcript.find(params[:id])
    @table_data = @tr.table_items.unshift(Replicate.all_stages)
    @name = "Transcript #{@tr.name}"
    haml :transcript
  end

  private

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


end

