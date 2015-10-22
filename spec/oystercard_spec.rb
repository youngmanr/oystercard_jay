
require 'oystercard'

describe OysterCard do

  subject(:oystercard) { described_class.new }

  let(:entry_station) {double :entry_station, name: :old_street, zone: :entry_zone }
  let(:exit_station) {double :exit_station, name: :baker_street, zone: :exit_zone }

  let(:journey) {double :journey}

  context 'initialization' do
    it 'has a default balance' do
      expect(oystercard.balance).to eq OysterCard::MIN_FARE
    end

    it 'the list of journeys is empty' do
      expect(oystercard.journeys).to be_empty
    end
  end

  context '#top_up' do
    it 'the balance can be topped up' do
      expect{ oystercard.top_up OysterCard::MIN_FARE}.to change{ oystercard.balance }.by OysterCard::MIN_FARE
    end

    it 'has a maximum balance' do
      expect{ oystercard.top_up(OysterCard::MAX_BALANCE) }.to raise_error("The maximum balance is #{OysterCard::MAX_BALANCE}")
    end
  end

  context 'BAD #touch_in without minimum balance' do
    it 'raises an error if min funds not available' do
      allow(journey).to receive(:entry_journey).with(entry_station).and_return(entry_station)
      allow(journey).to receive(:exit_journey).with(exit_station).and_return(exit_station)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect { oystercard.touch_in(entry_station) }.to raise_error "min funds not available"
    end
  end

  context 'BAD #touch_in followed by #touching_in' do
    it 'deducts the penalty fare on touch in' do
      allow(journey).to receive(:entry_journey).with(entry_station).and_return(entry_station)
      oystercard.touch_in(entry_station)
      expect{ oystercard.touch_in(entry_station) }.to change { oystercard.balance }.by -OysterCard::PENALTY_FARE
    end
  end

  context 'BAD #touch_out no #touching_in' do
    it 'deducts the penalty fare on touch out' do
      allow(journey).to receive(:exit_journey).with(exit_station).and_return(exit_station)
      expect{ oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -OysterCard::PENALTY_FARE
    end
  end

  context 'GOOD #touch_in followed by #touch_out' do
    it 'deducts the min fare on touch out' do
      allow(journey).to receive(:entry_journey).with(entry_station).and_return(entry_station)
      allow(journey).to receive(:exit_journey).with(exit_station).and_return(exit_station)
      oystercard.touch_in(entry_station)
      expect{ oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -OysterCard::MIN_FARE
    end
  end

  context 'GOOD #touch_in followed by #touch_out' do
    it 'adds a journey to journey history' do
      allow(journey).to receive(:entry_journey).with(entry_station).and_return(entry_station)
      allow(journey).to receive(:exit_journey).with(exit_station).and_return(exit_station)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys).not_to be_empty
    end
  end

end
