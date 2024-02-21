require "http"
require "json"

puts "Umbrella Checker"
puts 
puts "Enter city"
user_location = gets.chomp.capitalize
puts "checking the weather at #{user_location}...."

#gets environment variable
gmaps_key = ENV.fetch("GMAPS_KEY")
#user input with url
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"
#gets url
gmaps_data = HTTP.get(gmaps_url)
#parses into ruby objects
gmaps_parse = JSON.parse(gmaps_data)
#navigaing the data
results_arr = gmaps_parse.fetch("results")

first_result_hash = results_arr.at(0)

geometry_hash = first_result_hash.fetch("geometry")

location_hash = geometry_hash.fetch("location")

lati = location_hash.fetch("lat")

long = location_hash.fetch("lng")

puts "Your coordinates are #{lati}, #{long}."

#weather
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
pirate_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lati},#{long}"

pirate_data = HTTP.get(pirate_url)

pirate_parse = JSON.parse(pirate_data)

#current weather
currently = pirate_parse.fetch("currently")

temp_now = currently.fetch("temperature")

puts "It is currently #{temp_now}°F."

# future forecast
minutely = pirate_parse.fetch("minutely", false)

if minutely
  next_hour = minutely.fetch("summary")
  puts "Next hour: #{next_hour}"
end

hourly = pirate_parse.fetch("hourly")
hourly_data = hourly.fetch("data")
next_twelve_hours = hourly_data[1..12]

