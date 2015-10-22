require 'journey'

describe Journey do
  let ( :entry_station) {double :old_street}
  let ( :exit_station) {double :baker_street}

  subject( :journey) { described_class.new :old_street}

  it 'journey remembers entry station' do
    expect(journey.entry_station).to eq :old_street
  end

  it 'journey remembers exit station' do
    journey.exit_journey :baker_street
    expect(journey.exit_station).to eq :baker_street
  end

end