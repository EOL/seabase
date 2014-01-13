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

  # Should this be constrained to a taxon?
  get '/external_names/:id' do
    @en = ExternalName.find(params[:id])
    haml :external_name
  end

  get '/graph_test' do 
    @name = 'A0PJN4'
    @row1 = ['A',6161,3750,6097,0,0,6818,3256,0,11200,7030,12841,19105,
            17866,13156,16136,21079,25991,14865,19888,14275]
    @row2 = ['B',3082,6891,4166,11621,3980,0,0,4597,0,0,0,13326,20170,
            15724,19362,25053,27408,14136,19576,21808]
    @row3 = ['combined',4621,5321,5131,11621,3980,6818,3256,4597,11200,
            7030,12841,16216,19018,14440,17749,23066,26699,14501,19732,18041]

    @combined_data = get_combined(@row3.dup) 
    @separate_data = get_separate(@row1, @row2, @row3)
    haml :google_chart
  end

  def get_separate(r1, r2, r3)
    count = 0
    res = [['Hour', r1.shift, r2.shift, r3.shift ]]
    until r1.empty? do
      d1 = r1.shift.to_i
      d2 = r2.shift.to_i
      d3 = r3.shift.to_i
      d1 = nil if d1 == 0
      d2 = nil if d2 == 0
      d3 = nil if d3 == 0
      res << [count, d1, d2, d3]
      count+=1
    end
    res.to_json.gsub(/null/, '')
  end

  def get_combined(row)
    count = 0
    res = [['Hour', row.shift, {type: 'string', role: 'tooltip'} ]]
    until row.empty? do
      datum = row.shift
      res << [count, datum, "%s h\n%s amol/embr." % [count, datum]] if datum.to_i != 0
      count += 1
    end
    res
  end

end

