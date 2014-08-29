helpers do
  include Sinatra::RedirectWithFlash
  include Rack::Utils
  alias_method :h, :escape_html

  def format_graph_data(table_data)
    res = table_data.transpose
    res.each_with_index do |r, i|
      next if i == 0
      res[i] = define_element(r)
    end
    res.to_json
  end

  def format_cell_data(n)
    n = 0.0 if n && n < 0
    format = n ? n.round(2).to_s : "N/A"
    { v: n, f: format }
  end

  def gene_type(external_name, opts = { capitalize: false })
    res = external_name.taxon.scientific_name
    unless res == "Nematostella annotation"
      res = format("%s ortholog", external_name.taxon.common_name.downcase)
    end

    res = res.split(" ").map { |w| w.capitalize }.join(" ") if opts[:capitalize]
    res
  end

  def current_taxon
    scientific_name = (session && session[:scientific_name]) || "Mus musculus"
    Taxon.find_by_scientific_name(scientific_name)
  end

  private

  def define_element(result)
    element = []
    result.each_with_index do |n, i|
      cell_data = n
      cell_data = format_cell_data(n) if i > 0
      element << cell_data
    end
    element
  end
end
