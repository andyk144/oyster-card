class Journey
  attr_reader :log, :start_station, :end_station, :in_journey

  def initialize
    @log = []
    @start_station = nil
    @end_station = nil
  end

  def journey_start(station)
    @start_station = station
  end

  def journey_end(station)
    @end_station = station
    log_journey
    @start_station = nil
  end

  def log_journey
    @log << {start_station: @start_station, end_station: @end_station }
  end

  def in_journey?
    @start_station
  end

end
