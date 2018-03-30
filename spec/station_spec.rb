require 'station'

describe Station do

subject(:station) { described_class.new(name: "Coulsdon South", zone: 1) }

  it 'knows the station name' do
    expect(station.name).to eq("Coulsdon South")
  end

  it 'knows the zone of the station' do
    expect(station.zone).to eq(1)
  end
end
