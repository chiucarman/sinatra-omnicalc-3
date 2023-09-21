require "sinatra"
require "sinatra/reloader"
require "http"
require "sinatra/cookies"
require "better_errors"
require "binding_of_caller"

#Need this configuration for better_errors
use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
  # cookies["color"] = "purple"
end

get("/umbrella") do
  erb(:umbrella_form )
end

post("/process_umbrella") do
  # location info
  @user_location = params.fetch("user_loc")

  url_encoded_string = @user_location.gsub(" ", "+")

  gmaps_key = ENV.fetch("GMAPS_KEY")
  # @gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encoded_string}&key=#{gmaps_key}"

  @gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @user_location + "&key=" + ENV.fetch("GMAPS_KEY")

  @raw_response = HTTP.get(gmaps_url).to_s

  @parsed_response = JSON.parse(@raw_response)

  @loc_hash = @parsed_response.dig("results", 0, "geometry", "location")

  # @latitude = @loc_hash.fetch("lat")
  # @longitude = @loc_hash.fetch("lng")

  # weather info
  # weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
  # @weather_url = "https://api.pirateweather.net/forecast/#{weather_key}/#{@latitude},#{@longitude}"

  # cookies["last_location"] = @user_location
  # cookies["last_lat"] = @latitude
  # cookies["last_lng"] = @longitude

  erb(:umbrella_results)
end
