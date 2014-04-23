get '/css/:filename.css' do
  scss :"sass/#{params[:filename]}"
end

get '/' do
  @news = NewsPost.visible_news
  haml :home
end

get '/login' do
  haml :login
end

put '/default_ortholog' do
  session[:scientific_name] = params[:scientific_name]
end

post '/login' do
  eperson = password_authorization(email: params[:email], 
                                               password: params[:password])
  session[:current_user_id] = eperson.id if eperson
  redirect session[:previous_location] || '/' 
end

get '/logout' do
  session[:current_user_id] = nil
  redirect '/', info: 'You logged out'
end

get '/news' do
  authentication_required
  authorized_for_roles(['admin'])
  haml :news
end

post '/news_posts' do 
  NewsPost.create(user: current_user, 
                  subject: params[:subject], 
                  body: params[:body])
  redirect '/news'
end

get '/news/:id' do
  authentication_required
  authorized_for_roles(['admin'])
  @news_post = NewsPost.find(params[:id])
  haml :news_edit
end

put '/news' do
  @news_post = NewsPost.find(params[:id])
  @news_post.update(deleted: params[:deleted], 
                    subject: params[:subject], 
                    body: params[:body])
  haml :news_edit
end

delete '/news' do
  @news_post = NewsPost.find(params[:id])
  @news_post.delete
  haml :news
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
  @en = get_homolog(@tr)
  haml :transcript
end

get '/export' do
  haml :export
end

get '/import' do
  haml :import
end

get '/gephi_imports/:gephi_import_id' do
  @gephi_import = GephiImport.find(params[:gephi_import_id])
  @traces = Trace.where(gephi_import_id: @gephi_import.id)
  haml :gephi_import
end

get '/traces/:trace_id' do
  @trace = Trace.find(params[:trace_id])
  @table_data, @max_y = transcripts_data(@trace)
  @transcripts_json = format_graph_data(@table_data) 
  haml :trace
end

post '/upload_gephi' do
  file = params[:file]
  @gephi_import = GephiImport.process_file(file[:tempfile], params[:name])
  redirect "/gephi_imports/%s" % @gephi_import.id
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
  @average_data = format_graph_data(get_average_data(data))
  @fold_plot_data = File.read(File.join(settings.root, 'technical_files',
                                        'fold_plot_data.json')).strip
  @fold_plot_max = find_fold_plot_max(@fold_plot_data)
  haml :test_charts
end

get '/test_d3' do
  haml :test_d3
end

private

def get_homolog(transcript)
  transcript.external_names.select do |t| 
    t.taxon_id == current_taxon.id
  end.first
end

def transcripts_data(trace)
  data = [["Hours", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
           11, 12, 13, 14, 15, 16, 17, 18, 19]]
  transcript_ids = trace.gephi_records.map(&:transcript_id)
  max_y = 0
  transcript_ids.each do |id|
    tr = Transcript.find(id)
    values = Transcript.connection.select_values("
      select sum(count) 
      from normalized_counts 
      where transcript_id = %s 
      group by stage order by stage" % id)
    max_val = values.max
    max_y = max_val if max_val && max_val > max_y
    homolog = get_homolog(tr)
    name = homolog ? homolog.name : tr.name
    values.unshift(name)
    data << values
  end

  [data, max_y]
end

def get_average_data(data)
  head = data[0]
  data = data.transpose
  data.shift
  data = data.map do |d|
    avg = d.inject { |sum, i| sum + i }/d.size.to_f
    avg = 0.0 if avg < 0
    avg
  end
  data.unshift("Average")
  data = [data]
  data.unshift(head)
end

def find_fold_plot_max(data)
  data = JSON.parse(data)
  data.shift
  data = data.transpose
  max_y = data.shift.max
  max_x = data.shift.max
  max = [max_y, max_x].max
  Seabase.maxup(max)
end

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

def current_user
  return nil unless session[:current_user_id]
  User.where(id: session[:current_user_id]).first
end

def authentication_required
  session[:previous_location] = request.fullpath
  unless session[:current_user_id] && session[:current_user_id].to_i > 0
    redirect '/login', 
      info: "Please login to see the '%s' page." % request.path
  end
end

def authorized_for_roles(roles = [])
  return true if roles.empty?
  size = current_user.roles.size
  authorized = (current_user.roles_names - roles).size < size
  unless authorized
    redirect '/', 
      error: "You are not authorized to access '%s' page." % request.path
  end
end

def password_authorization(opts = {})
  return nil unless opts[:email] && opts[:password]
  user = User.where(email: opts[:email]).
    where(password_hash: Digest::SHA1.hexdigest(opts[:password].strip)).first
  if user
    session[:current_user_id] = user.id
  end
  user
end
