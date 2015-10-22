class Station

  attr_reader :name, :zone

  STATIONS = {:old_street => 1, :baker_street => 2, :wimbledon => 3}

  def initialize (name)
    @name = name
    @zone = STATIONS[name]
  end

end