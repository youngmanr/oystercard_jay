require 'station'

describe Station do

  subject(:station) { described_class.new( :old_street) }

  describe 'initialization' do
    it 'a new station has a name' do
      expect(station.name).to eq :old_street
    end

    it 'a new station has a zone' do
      expect(station.zone).not_to be nil
    end
  end

end

