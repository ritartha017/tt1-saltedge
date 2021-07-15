require 'spec_helper'

require_relative "../../lib/models/playlist"

describe Models::Playlist do
  before do
    @json = JSON.parse(File.read("spec/fixtures/playlist.json"))
    @playlist = Models::Playlist.new(@json)
  end

  context 'validation tests' do
    let(:track) { [{ "name" => "All The Pretty Little Horsies", 
                    "artist_name" => "Current 93", 
                    "album_name" => "The Inmost Light", 
                    "spotify_url" => "https://open.spotify.com/artist/7vF3DcPluq6lZI36VniagW", 
                    "id" => "6LRn9mc7W1lsxyirdYegH4" }] }

    # Playlist class attrs - :id, :name, :description, :owner_name, :spotify_url, :tracks
    it 'should have the correct accessors' do
      expect(@playlist).to have_attributes(:name => @json['name'])
      expect(@playlist).to have_attributes(:description => @json['description'])
      expect(@playlist).to have_attributes(:owner_name => @json['owner_name'])
      expect(@playlist).to have_attributes(:spotify_url => @json['spotify_url'])
      expect(@playlist).to have_attributes(:id => @json['id'])
      expect(@playlist.tracks.empty?).to be true
    end

    it '.add_tracks' do
      @playlist.add_tracks(track)
      expect(@playlist.tracks.class).to eq(Array)
      expect(@playlist.tracks[0]).to be_a(Models::Track)
    end
    
    it '.wrap_to_json' do
      expect(valid_json?(@playlist.wrap_to_json)).to be true
    end
  end
end
