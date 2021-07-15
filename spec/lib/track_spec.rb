require 'spec_helper'

require_relative "../../lib/models/track"

describe Models::Track do
  before(:each) do
    @json = JSON.parse(File.read("spec/fixtures/track.json"))
    @track = Models::Track.new(@json[1])
  end

  # Track class attrs - :id, :name, :artist_name, :album_name, :spotify_url
  it 'should have the correct accessors' do
    expect(@track).to have_attributes(:id => @json[1]['id'])
    expect(@track).to have_attributes(:name => @json[1]['name'])
    expect(@track).to have_attributes(:artist_name => @json[1]['artist_name'])
    expect(@track).to have_attributes(:album_name => @json[1]['album_name'])
    expect(@track).to have_attributes(:spotify_url => @json[1]['spotify_url'])
  end
end
