
def parse_uri_to_id(uri)
  uri.split(/: */).last
end

# Parse JSON @playlist_data into a hash.
def parse_playlist(playlist_data)
  playlist = {}
  playlist[:id] = playlist_data['id']
  playlist[:name] = playlist_data['name']
  playlist[:description] = playlist_data['description']
  playlist[:owner_name]  = playlist_data['owner']['display_name']
  playlist[:spotify_url] = playlist_data['external_urls']['spotify']
  playlist
end

# Parse tracks from JSON @playlist_data into array of hashes.
def parse_tracks(playlist_data)
  tracks = []
  playlist_data['tracks']['items'].each_with_index do |val, index|
    track = {}
    track[:name] = playlist_data['tracks']['items'][index]['track']['name']
    track[:artist_name] = playlist_data['tracks']['items'][index]['track']['album']['artists'][0]['name']
    track[:album_name] = playlist_data['tracks']['items'][index]['track']['album']['name']
    track[:spotify_url] = playlist_data['tracks']['items'][index]['track']['album']['artists'][0]['external_urls']['spotify']
    track[:id] = playlist_data['tracks']['items'][index]['track']['id']
    tracks << track
  end
  tracks
end

def valid_json?(json)
  JSON.parse(json)
  true
rescue
  false
end
