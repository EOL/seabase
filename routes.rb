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

  post '/search' do
    scientific_name = params[:scientific_name]
    # scientific_name = params[:organism] # Currently ignored
    term = params[:term]
    @external_identifiers = ExternalMatch.like_ei_search(scientific_name, term)
    haml :search_result
  end

end

