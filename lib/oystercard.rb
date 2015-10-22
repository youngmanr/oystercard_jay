class OysterCard

  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance, :entry_station, :journeys, :exit_station

  def initialize
    @balance = 0
    @entry_station = nil
    @journeys = []
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station)
    raise "min funds not available" if balance < MIN_FARE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MIN_FARE)
    @journeys << { entry_station: @entry_station, exit_station: station }
    @entry_station = nil
  end

  def top_up(amount)
    fail "The maximum balance is #{MAX_BALANCE}" if amount + balance >= MAX_BALANCE
    @balance += amount
  end

  private

  def deduct(amount)
 	  @balance -= amount
  end

end
