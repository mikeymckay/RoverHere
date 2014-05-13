RoverHere
=========

Change your Ubuntu Desktop background to be a satellite image of your current location at a random zoom level.


Install it
==========

    wget https://github.com/mikeymckay/RoverHere/raw/master/map.rb
    gem install capybara capybara/dsl capybara-screenshot rest-client activesupport capybara/poltergeist

Run it
======

    ruby map.rb

Cron it
=======

    (crontab -l ; echo "*/5 * * * * /usr/bin/ruby /path/to/RoverHere/map.rb")| crontab -

 
*How*: A rubyscript that uses geoip to get your location, then capybara poltergeist guides phantomjs to hit the google maps page for your current location, take a screenshot and then make it your new desktop background.
    
*Coming Soon*: OS X Support

*Thanks*: I stole the idea from: https://github.com/tomtaylor, who first made it work on OSX: http://satelliteeyes.tomtaylor.co.uk/
