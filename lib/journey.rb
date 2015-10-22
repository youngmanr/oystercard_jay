class Journey
  attr_reader :entry_station, :exit_station

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def initialize station
    @entry_station = station
  end

  def complete
    (entry_station != nil) && (exit_station != nil)
  end

  def exit_journey station
    exit_station = station
  end

  def fare
    complete ? MINIMUM_FARE : PENALTY_FARE
  end
end