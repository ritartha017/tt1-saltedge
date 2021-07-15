require 'spec_helper'

require_relative '../../lib/models/playlist'

describe Models::Playlist do
  context 'validation tests' do
    let(:fixture) { JSON.parse(File.read('spec/fixtures/playlist.json')) }
    let(:tracks) { JSON.parse(File.read("spec/fixtures/track.json")) }

    # Playlist class attrs - :id, :name, :description, :owner_name, :spotify_url, :tracks
    it 'should have the correct accessors' do
      $playlist = Models::Playlist.new(fixture)
      expect($playlist.name).to         eq(fixture['name'])
      expect($playlist.description).to  eq(fixture['description'])
      expect($playlist.owner_name).to   eq(fixture['owner_name'])
      expect($playlist.spotify_url).to  eq(fixture['spotify_url'])
      expect($playlist.id).to           eq(fixture['id'])
      expect($playlist.tracks.empty?).to be true
    end

    it '.add_tracks' do
      $playlist.add_tracks(tracks)
      expect($playlist.tracks.class).to eq(Array)
      expect($playlist.tracks[0]).to be_a(Models::Track)
    end
    
    it '.wrap_to_json' do
      expect(valid_json?($playlist.wrap_to_json)).to be true
    end
  end
end
