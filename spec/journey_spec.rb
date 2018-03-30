require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:station_1) { double :station }
  let(:station_2) { double :station }

  it 'starts with an empty journey history' do
    expect(journey.log).to be_empty
  end

  describe '#journey_start' do
    it 'gets the start station of the journey' do
      expect(journey.journey_start(station_1)).to eq(station_1)
    end
  end

  describe '#journey_end' do
    it 'gets the end station of the journey' do
      expect { journey.journey_end(station_1) }.to change { journey.end_station }.from(nil).to(station_1)
    end

    it 'resets the start station to nil' do
      journey.journey_start(station_1)
      expect { journey.journey_end(station_2) }.to change { journey.start_station }.from(station_1).to(nil)
    end

  end

  describe '#log_journey' do
    it 'logs a journey when complete' do
      journey.journey_start(station_1)
      journey.journey_end(station_2)
      expect(journey.log).to include({start_station: station_1, end_station: station_2})
    end

  end

  describe '#in_journey' do
    it 'shows the card status is in journey once tapped in' do
      journey.journey_start(station_1)
      expect(journey).to be_in_journey
    end

    it 'shows the card status is not in journey once tapped out' do
      journey.journey_end(station_2)
      expect(journey).not_to be_in_journey
    end
  end
end
