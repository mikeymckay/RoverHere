#! /usr/bin/env ruby
require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara-screenshot'
require 'rest-client'
require 'active_support/all'
require 'tempfile'
require 'capybara/poltergeist'

#Capybarai & poltergeist makes it easy to load a URL in PhantomJS and take a screenshot
Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.default_wait_time = 60
Capybara::Screenshot.autosave_on_failure = false
Capybara.save_and_open_page_path = "/tmp"
include Capybara::DSL

# For OSX: http://superuser.com/questions/447295/how-can-i-get-the-current-screen-resolution-from-the-command-line-on-os-x
(screenWidth, screenHeight) = `DISPLAY=:0 xdpyinfo | awk '/dimensions:/ { print $2; exit }'`.chomp().split(/x/)
page.driver.resize(screenWidth, screenHeight)

# For OS X use LocateMe
# Run some python code to get the lat/long
geoCodeSetup = "
import Geoclue
location = Geoclue.DiscoverLocation()
location.init()
location.set_position_provider('Ubuntu GeoIP')
position = location.get_location_info()"
lat  = `python -c "#{geoCodeSetup}\nprint position['latitude']"`
long = `python -c "#{geoCodeSetup}\nprint position['longitude']"`

zoomlevel = (4..21).to_a.sample # random number between 4 and 21
decimals = 0
if zoomlevel > 20
  decimals = 4
elsif zoomlevel > 10
  decimals = 3
elsif zoomlevel > 5
  decimals = 2
elsif zoomlevel > 3
  decimals = 1
end
filename_lat = sprintf "%.#{decimals}f", lat
filename_long = sprintf "%.#{decimals}f", long
filename = "/var/www/RoverHere/images/#{filename_lat}_#{filename_long}_#{zoomlevel}_#{screenWidth}_#{screenHeight}.png"
if not File.exist? filename
  visit "https://maps.google.com/?ll=#{lat},#{long}&spn=0.007244,0.016512&t=k&z=#{zoomlevel}&output=svembed&layer=c"
  save_screenshot(filename)
end

# Update the background
# For OS X you can: http://stackoverflow.com/questions/431205/how-can-i-programatically-change-the-background-in-mac-os-x
`gsettings set org.gnome.desktop.background picture-uri "file://#{filename}"`
