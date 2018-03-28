require 'oyster_card'

describe OysterCard do
  subject(:oyster_card) { OysterCard.new }
  subject(:oyster_card10) { OysterCard.new(10) }
  let(:start_station) { double :station }
  let(:end_station) { double :station }

  it 'responds with a balance of 0' do
    expect(oyster_card.balance).to eq 0
  end

  it 'starts with an empty journey history' do
    expect(oyster_card.journey_history).to be_empty
  end

  it 'has a record of the last touched in station' do
    expect(oyster_card).to respond_to (:last_touch_in)
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

    it 'records the last station touched in' do
      oyster_card10.touch_in(start_station)
      expect(oyster_card10.last_touch_in).to eq start_station
    end

    context 'when already touched in' do
      it 'raises an error' do
        allow(oyster_card).to receive(:touched_in?).and_return true
        expect{ oyster_card.touch_in(start_station) }.to raise_error 'You are already touched in'
      end
    end
  end

  describe '#touch_out' do

    it 'charges minimum fare for a journey on touch out' do
      oyster_card10.touch_in(start_station)
      expect { oyster_card10.touch_out(end_station) }.to change { oyster_card10.balance }.from(10).to(9)
    end

    it 'forgets the touched in station on touch out' do
      oyster_card10.touch_in(start_station)
      oyster_card10.touch_out(end_station)
      expect(oyster_card10.last_touch_in).to be_nil
    end

    it 'records the exit station' do
      oyster_card10.touch_in(start_station)
      oyster_card10.touch_out(end_station)
      expect(oyster_card10.last_touch_out).to eq end_station
    end
  end

  describe '#touched_in?' do
    it 'returns true when touched in' do
      oyster_card10.touch_in(start_station)
      expect(oyster_card10).to be_touched_in
    end

    it 'returns false when not touched in' do
      oyster_card10.touch_in(start_station)
      oyster_card10.touch_out(end_station)
      expect(oyster_card10).not_to be_touched_in
    end
  end

  describe '#journey_history' do
    let(:journey) {{:Start_Destination => start_station, :End_Destination => end_station}}
    it 'shows your journey history' do
      oyster_card10.touch_in(start_station)
      oyster_card10.touch_out(end_station)
      expect(oyster_card10.journey_history).to include(journey)
    end
  end

end
