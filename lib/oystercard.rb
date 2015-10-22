

class OysterCard

  MAX_BALANCE = 90
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :balance, :journeys, :current_journey

  def initialize
    @balance = 0
    @current_journey = nil
    @journeys = []
  end

  def touch_in(station)
    raise "min funds not available" if balance < MIN_FARE
    unless @current_journey == nil
      @current_journey.exit_journey( station)
      deduct(@current_journey.fare)
      @journeys << @current_journey
    end
    @current_journey = Journey.new( station)
  end

  def touch_out(station)
    if current_journey == nil
      @current_journey = Journey.new(nil)
    end

    @current_journey.exit_journey( station)
    deduct(@current_journey.fare)
    @journeys << @current_journey
    @current_journey = nil
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
