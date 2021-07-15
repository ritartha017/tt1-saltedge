require_relative 'track'

module Models
  class Playlist
    attr_accessor :id, :name, :description, :owner_name, :spotify_url, :tracks
    
    @@tracks = []

    def initialize(attrs = {})
      attrs.each do |k, val|
        self.send "#{k}=", val
      end
    end

    def add_tracks(tracks)
      tracks.each_with_index do |track, index|
        @@tracks << Track.new(track)
      end
    end

    def tracks
      @@tracks
    end

    def wrap_to_json
      my_tracks = []
      @@tracks.each_with_index do |track, index|
        t_hash = {}
        t_hash[:name]        = @@tracks[index].name
        t_hash[:artist_name] = @@tracks[index].artist_name
        t_hash[:album_name]  = @@tracks[index].album_name
        t_hash[:spotify_url] = @@tracks[index].spotify_url
        t_hash[:id]          = @@tracks[index].id
        my_tracks << t_hash
      end

      my_playlist = { name: @name, 
                      description: @description, 
                      owner_name: @owner_name, 
                      spotify_url: @spotify_url, 
                      id: @id, 
                      tracks: my_tracks
                    }
      @json = JSON.pretty_generate(my_playlist)
    end
  end # Playlist
end #Models

