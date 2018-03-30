require_relative 'journey'

class OysterCard
  attr_reader :balance, :journey_history
  MAX_CAPACITY = 90
  MIN_CAPACITY = 1
  PENALTY_FARE = 5

  def initialize(balance = 0)
    @balance = balance
    @journey_history = Journey.new
  end

  def touch_in(station)
    fare(PENALTY_FARE) if @journey_history.in_journey?
    raise 'Not enough balance' if @balance < MIN_CAPACITY
    @journey_history.journey_start(station)
  end

  def touch_out(station)
    journey_history.in_journey? ? fare(MIN_CAPACITY) : fare(PENALTY_FARE)
    @journey_history.journey_end(station)
  end

  def top_up(amount)
    raise "Max balance of #{MAX_CAPACITY} exceeded" if exceed_limit?(amount)
    @balance += amount
  end

  private

  def fare(amount)
    @balance -= amount
    raise 'Penalty fare charged' if amount == PENALTY_FARE
  end

  def exceed_limit?(amount)
    @balance + amount > MAX_CAPACITY
  end
end
