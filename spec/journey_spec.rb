require 'journey'

describe Journey do
  let ( :station) {double :old_street}
  subject( :journey) { described_class.new station}

  it {is_expected.to respond_to :entry_station}
  it {is_expected.to respond_to :exit_station}

  it 'stores entry station as variable' do
    expect(journey.entry_station).to eq station
  end

end