require 'oystercard'

describe OysterCard do

  subject(:oystercard) { described_class.new }

  let(:entry_station) {double :entry_station, name: :old_street, zone: :entry_zone }
  let(:exit_station) {double :exit_station, name: :baker_street, zone: :exit_zone }

  describe 'initialization' do
    it 'has a default balance of 0' do
      expect(oystercard.balance).to eq 0
    end

    it 'a new oystercard is not in journey' do
      expect(oystercard.in_journey?).to be false
    end

    it 'the list of journeys is empty' do
      expect(oystercard.journeys).to be_empty
    end
  end

  describe '#top_up' do
    it 'the balance can be topped up' do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end

    it 'has a maximum balance' do
      expect{ oystercard.top_up(OysterCard::MAX_BALANCE) }.to raise_error("The maximum balance is #{OysterCard::MAX_BALANCE}")
    end
  end

  describe '#touch_in' do

    it 'is in journey after card has touched in' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end

    it 'raises an error if min funds not available' do
      expect { oystercard.touch_in(entry_station) }.to raise_error "min funds not available"
    end

    it 'stores entry station as variable' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
    end
  end

  describe '#touch_out' do

    it 'is not in journey after card has touched out' do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end

    it 'deducts the fare on touch out' do
      expect{ oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -OysterCard::MIN_FARE
    end

    it 'adds a journey to journey history' do
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys).not_to be_empty
    end
  end

  describe 'journeys' do
    before do
      oystercard.top_up(10)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
    end

    it 'journey contains information about entry zones' do
      expect(oystercard.journeys.last[:entry_station].zone).to eq :entry_zone
    end

    it 'journey contains information about exit zones' do
      expect(oystercard.journeys.last[:exit_station].zone).to eq :exit_zone
    end
  end
end
