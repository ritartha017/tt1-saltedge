module Models
  class Track
    attr_accessor :id, :name, :artist_name, :album_name, :spotify_url

    def initialize(attrs = {})
      attrs.each do |k, val|
        self.send "#{k}=", val
      end
    end 
  end # Track
end # Models
