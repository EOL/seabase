class SeabaseApp < Sinatra::Base
  helpers do

    def show_alignment(data)
      step = 51
      count = 0
      hseq = data.hseq 
      midline = data.midline
      qseq = data.qseq 
      res = ''
      while hseq[count...count + step] do
        res += hseq[count...count + step] + "<br/>"
        res += midline[count...count + step] + "<br/>"
        res += qseq[count...count + step] + "<br/>"
        count += step
      end
      res
    end
  end
end
