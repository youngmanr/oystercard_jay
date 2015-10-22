

class OysterCard

  MAX_BALANCE = 90
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :balance, :journeys, :current_journey

  def initialize
    @balance = MIN_FARE
    @current_journey = nil
    @journeys = []
  end

  def touch_in(station)
    raise "min funds not available" if balance < MIN_FARE
    unless @current_journey == nil
      complete_current_journey nil
    end
    @current_journey = Journey.new( station)
  end

  def touch_out(station)
    if current_journey == nil
      @current_journey = Journey.new(nil)
    end

    complete_current_journey station
    @current_journey = nil
  end

  def top_up(amount)
    fail "The maximum balance is #{MAX_BALANCE}" if amount + balance >= MAX_BALANCE
    @balance += amount
  end

  private

  def deduct_fare(amount)
 	  @balance -= amount
  end

  def complete_current_journey station
    @current_journey.exit_journey( station)
    deduct_fare(@current_journey.fare)
    @journeys << @current_journey
  end

end
