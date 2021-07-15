require 'cgi'
require 'uri'
require 'json'

require_relative 'lib/api/api_client'
require_relative 'lib/models/playlist'
require_relative 'lib/models/track'
 
def create_playlist_for_my_user
    url = Api::Client::build_an_URL()
    spotify_callback_url = Api::Client::completes_authorization(url)

    @user = {}
    @user['auth_code'] = spotify_callback_url['code'].join()
    @user['access_token'] = access_token = Api::Client::get_access_token(@user['auth_code'])
    @user = @user.merge!(Api::Client::get_profile_data(access_token))

    @new_playlist = Api::Client::create_playlist(access_token, @user['id'], 'My new playlist', 'My awesome description!')
    tracks = [
        'spotify:track:18bjR8nOi853iJS8XBpdHU',
        'spotify:track:7hS3i9y9gi81OOFT1rCfSU',
        'spotify:track:6LRn9mc7W1lsxyirdYegH4',
        'spotify:track:11rsK9GDZ9UdWsxtDqnMmN',
        'spotify:track:631B0Vtr5oMc6GJJNXZLnp',
        'spotify:track:46Z1ogcP9C9UxBD1aO2iRR',
        'spotify:track:2LJZE1yXy9SdglruufEDHG'
    ]

    playlist_id =  @new_playlist["uri"]
    Api::Client::add_tracks_to_playlist(access_token, playlist_id, tracks)
    Api::Client::place_first_track_to_the_end(access_token, playlist_id, tracks.length)
    # Api::Client::remove_last_track_from_playlist(access_token, playlist_id, tracks[tracks.length - 1])
    @playlist_data = Api::Client::get_a_playlist_data(access_token, playlist_id)
end 

@playlist_data = JSON.parse(create_playlist_for_my_user())

tracks   = parse_tracks(@playlist_data)
playlist = parse_playlist(@playlist_data)

@my_playlist = Models::Playlist.new(playlist)
@my_playlist.add_tracks(tracks)

out = @my_playlist.wrap_to_json()
puts out 
File.write('spec/fixtures/outputs/playlist1.json', out)

