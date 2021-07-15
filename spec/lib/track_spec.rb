require 'spec_helper'

require_relative "../../lib/models/track"

describe Models::Track do
  let(:json) { JSON.parse(File.read("spec/fixtures/track.json")) }

  # Track class attrs - :id, :name, :artist_name, :album_name, :spotify_url
  it 'should have the correct accessors' do
    @track = Models::Track.new(json.first)
    expect(@track.id).to          eq(json[0]['id'])
    expect(@track.name).to        eq(json[0]['name'])
    expect(@track.artist_name).to eq(json[0]['artist_name'])
    expect(@track.album_name).to  eq(json[0]['album_name'])
    expect(@track.spotify_url).to eq(json[0]['spotify_url'])
  end
end
