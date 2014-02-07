helpers do

  include Rack::Utils
  alias_method :h, :escape_html
 
  def format_graph_data(table_data)
    res = table_data.transpose
    res.each_with_index do |r, i|
      next if i == 0
      element = []
      r.each_with_index do |n, ii| 
        cell_data = n
        if ii > 0 
          cell_data = format_cell_data(n)
        end
        element << cell_data
      end 
      res[i] = element
    end
    res.to_json
  end

  def format_cell_data(n)
    n = 0.0 if n && n < 0
    format = n ? n.round(2).to_s : 'N/A'
    { v: n, f: format } 
  end

  def gene_type(external_name, opts = { capitalize: false })
    taxon = external_name.taxon.scientific_name
    res = nil
    if taxon == 'Nematostella vectensis'
      res = 'Nematostella annotation'
    else
      res = "%s ortholog" % external_name.taxon.common_name.downcase
    end

    if opts[:capitalize] 
      res = res.split(' ').map { |w| w.capitalize }.join(' ') 
    end
    res
  end
end
