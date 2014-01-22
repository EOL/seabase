require_relative 'spec_helper'

describe SeabaseApp do
  describe '/' do
    it 'renders' do
      visit '/'
      expect(page.status_code).to eq 200
      expect(page.body).to match 'SeaBase'
    end
  end
end


