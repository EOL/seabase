class SeabaseApp < Sinatra::Base

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
    blast = Seabase::Blast.new('blastn')
    @seq = params[:sequence]
    @blast_result = blast.search(@seq)
    haml :blast_result
  end

end

