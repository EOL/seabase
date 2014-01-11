require_relative '../spec_helper'

describe Seabase do
  subject(:seabase) { Seabase.new }
  describe '.new' do
    it 'initializes' do
      expect(:seabase).to be_kind_of Seabase
    end
  end
end
