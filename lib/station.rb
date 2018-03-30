class Station
  attr_reader :name, :zone

  def initialize(name: name, zone: zone)
    @name = name
    @zone = zone
  end
end
