require 'watir'
require 'rest-client'

require_relative '../../utils/parsers'

module Api
  module Client
    CLIENT_CALLBACK_URL = 'http://127.0.0.1:4567/'
    CLIENT_ID     = 'd20ba0d4d0a6415fa68fad8a9258a329'
    CLIENT_SECRET = '47d0f21bfc5041259727815507d2808f'
    LOGIN, PASS   = 'your_login', 'your_pass'
    SCOPES        = 'user-read-private user-read-email playlist-modify-public playlist-modify-private'
    AUTHORIZE     = 'https://accounts.spotify.com/authorize'
    
    def self.build_an_URL
      url = 
        AUTHORIZE + 
        '?response_type=code' +
        '&client_id='    + CLIENT_ID +
        '&scope='        + SCOPES +
        '&redirect_uri=' + CLIENT_CALLBACK_URL
    end

    # Return an Spotify callback url.
    def self.completes_authorization(url)
      browser = Watir::Browser.start url
      browser.text_field(name: 'username').set LOGIN
      browser.text_field(name: 'password').set PASS
      browser.button(id: 'login-button').click
      Watir::Wait.until { browser.url.match(/#{CLIENT_CALLBACK_URL}/) }
      CGI.parse(URI.parse(browser.url).query)
    end

    # Parses the code from the callback URL and exchanges it for an @access_token.
    def self.get_access_token(auth_code)
      uri = 'https://accounts.spotify.com/api/token'
      body = {
        grant_type:     'authorization_code',
        code:            auth_code,
        redirect_uri:    CLIENT_CALLBACK_URL,
        client_id:       CLIENT_ID,
        client_secret:   CLIENT_SECRET
      }
      res = RestClient::Request.execute(method: :post, url: uri, payload: body)
      access_token = JSON.parse(res.body)['access_token']
    end

    def self.get_profile_data(access_token)
      url = 'https://api.spotify.com/v1/me'
      res = RestClient.get(url, { Authorization: "Bearer #{access_token}" })
      JSON.parse(res.body)
    end

    # Creates a new playlist called @name.
    def self.create_playlist(access_token, user_id, name, description)
      uri = "https://api.spotify.com/v1/users/#{user_id}/playlists"
      res = RestClient.post(uri, { name: name, description: description, public: true }.to_json, { Authorization: "Bearer #{access_token}"})
      JSON.parse(res.body)
    end

    # Adds several @tracks to the @playlist_id. 
    def self.add_tracks_to_playlist(access_token, playlist_id, tracks)
      uri = "https://api.spotify.com/v1/playlists/#{parse_uri_to_id(playlist_id)}/tracks"
      res = RestClient.post(uri, { 'uris': tracks, 'position': 0 }.to_json, 'Content-Type' => 'application/json', Authorization: "Bearer #{access_token}", "position" => 0 )
      JSON.parse(res.body)
    end

    # Reorders the @playlist_id by placing the first track at the end of the list.
    def self.place_first_track_to_the_end(access_token, playlist_id, position)
      uri = "https://api.spotify.com/v1/playlists/#{parse_uri_to_id(playlist_id)}/tracks"
      res = RestClient.put(uri, { 'range_start': 0, 'insert_before': position }.to_json, { Authorization: "Bearer #{access_token}" })
     JSON.parse(res.body)
    end

    # Removes the last track from your @playlist_id.
    def self.remove_last_track_from_playlist(access_token, playlist_id, track)
      uri = "https://api.spotify.com/v1/playlists/#{parse_uri_to_id(playlist_id)}/tracks"
      body = { "tracks": [{ "uri": track }] }.to_json
      header = { 'Content-Type' => 'application/json', Authorization: "Bearer #{access_token}" }
      res = RestClient::Request.execute(method: :delete, url: uri, payload: body, headers: header)
      JSON.parse(res.body)
    end
    
    # Requests the @playlist_id and return a JSON response. 
    def self.get_a_playlist_data(access_token, playlist_id)
      uri = "https://api.spotify.com/v1/playlists/#{parse_uri_to_id(playlist_id)}"
      res = RestClient.get(uri, { Authorization: "Bearer #{access_token}" })
    end
  end # Client
end # Api

