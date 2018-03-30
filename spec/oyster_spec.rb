require 'oyster_card'
require 'journey'

describe OysterCard do
  subject(:oyster_card) { OysterCard.new }
  subject(:oyster_card10) { OysterCard.new(10) }
  let(:start_station) { double :station }
  let(:end_station) { double :station }

  it 'responds with a balance of 0' do
    expect(oyster_card.balance).to eq 0
  end

  describe '#top_up' do
    it 'increases balance by specified amount' do
      oyster_card.top_up(10)
      expect(oyster_card.balance).to eq 10
    end
  end

  describe '#exceed_limit?' do
    it 'returns true when limit exceeded' do
      expect(oyster_card.send(:exceed_limit?, 91)).to eq(true)
    end
  end

  describe '#touch_in' do

    it 'should prevent touching in when balance is too low' do
      expect{ oyster_card.touch_in(start_station) }.to raise_error 'Not enough balance'
    end

    context 'when already touched in' do
      it 'charges a penalty fare if touched in again without touching out' do
        oyster_card10.touch_in(start_station)
        expect{ oyster_card10.touch_in(start_station) }.to change {oyster_card10.balance}.by(described_class::PENALTY_FARE)
      end
    end
  end

  describe '#touch_out' do

    it 'charges minimum fare for a journey on touch out' do
      oyster_card10.touch_in(start_station)
      expect { oyster_card10.touch_out(end_station) }.to change { oyster_card10.balance }.from(10).to(9)
    end
  end

  describe '#touched_in?' do
    it 'returns true when touched in' do
      oyster_card10.touch_in(start_station)
      expect(oyster_card10.journey_history.in_journey?).to be_in_journey
    end

    it 'returns false when not touched in' do
      oyster_card10.touch_in(start_station)
      oyster_card10.touch_out(end_station)
      expect(oyster_card10.journey_history.in_journey?).not_to be_in_journey
    end
  end

  describe '#fare' do
    it 'charges the minimum fare for a journey' do
      oyster_card10.touch_in(start_station)
      expect(oyster_card10.touch_out(end_station)).to change { oyster_card10.balance }.by(described_class::MIN_CAPACITY)
    end

    it 'raises a penalty fare message' do
      expect{ oyster_card10.fare(described_class::PENALTY_FARE) }.to raise_error 'Penalty fare charged'

    end

    it 'charges the penalty fare' do
      oyster_card10.touch_out(start_station)
      expect{ oyster_card10.touch_out(end_station) }.to change { oyster_card10.balance }.by(described_class::PENALTY_FARE)
    end
  end


end
