#!/usr/bin/env ruby

# A: Common Name
# B: Genus
# C: Species (Latin)
# D: Number
# E: Species Comments
# F: Location Name
# G: Latitude
# H: Longitude
# I: Date
# J: Start Time
# K: State/Province
# L: Country Code
# M: Protocol
# N: Number of Observers
# O: Duration
# P: All observations reported?
# Q: Distance Covered
# R: Area Covered
# S: Checklist comments

# see Sighting.to_ebird_record_format

# aCollection = Trip.find_by_id(733).sightings


def writeToFile(aCollection, aFilename)
	rows = aCollection.collect { | sighting |
		sighting.to_ebird_record_format()
	}

	File.open(aFilename, 'w') { |file|
		rows.each do | row |
			file.write("%s\n" % row.join(','))
		end	
	}	

	puts "wrote %d sightings to %s" % [aCollection.count(), aFilename]
end


options = {}        

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: exportEbirdRecordFormat.rb -m month -y year"

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end             

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end

  options[:year] = nil
  opts.on( '-y', '--year NNNN', 'export sightings for year' ) do|year|
    options[:year] = year
  end

  options[:month] = nil
  opts.on( '-m', '--month NN', 'export sightings for month' ) do|month|
    options[:month] = month
  end

end         


# PARSE ARGUMENTS 'parse!' method parses ARGV and removes any options found there, as well as any parameters
# for the options.
optparse.parse!    

aCollection = {}

if options[:month] and options[:year]
	aCollection = Sighting.find_by_sql("SELECT DISTINCT sightings.* FROM trips, sightings
	      WHERE sightings.exclude!=1 AND sightings.trip_id=trips.id AND Year(trips.date)=%s AND Month(trips.date)=%s" % [options[:year], options[:month]])
	writeToFile(aCollection, 'ebird-%s-%s.txt' % [options[:year], options[:month]])
elsif options[:year]
	aCollection = Sighting.find_by_sql("SELECT DISTINCT sightings.* FROM trips, sightings
	       WHERE sightings.exclude!=1 AND sightings.trip_id=trips.id AND Year(trips.date)=%s" % options[:year])
	writeToFile(aCollection, 'ebird-%s.txt' % options[:year])
end

# rows = aCollection.collect { | sighting | sighting.to_ebird_record_format() }

# rows.each do | row |
#   puts row.join(',')
# end