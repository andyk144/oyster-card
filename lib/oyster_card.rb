class OysterCard
  attr_reader :balance, :in_journey, :last_touch_in, :last_touch_out, :journey_history
  MAX_CAPACITY = 90
  MIN_CAPACITY = 1

  def initialize(balance = 0)
    @balance = balance
    @last_touch_in = nil
    @last_touch_out = nil
    @journey_history = {}
  end

  def touch_in(station)
    raise 'You are already touched in' if touched_in?
    raise 'Not enough balance' if @balance < MIN_CAPACITY
    @last_touch_in = station
    @journey_history[:Start_Destination] = @last_touch_in
  end

  def touch_out(station)
    raise "You've already touched out" unless touched_in?
    deduct(MIN_CAPACITY)
    @last_touch_in = nil
    @last_touch_out = station
    @journey_history[:End_Destination] = @last_touch_out
  end

  def touched_in?
    @last_touch_in
  end

  def top_up(amount)
    raise "Max balance of #{MAX_CAPACITY} exceeded" if exceed_limit?(amount)
    @balance += amount
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def exceed_limit?(amount)
    @balance + amount > MAX_CAPACITY
  end
end
