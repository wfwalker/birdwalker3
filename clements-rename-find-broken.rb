#!/usr/bin/env ruby

require File.expand_path('../config/boot', __FILE__)

# need CSV package to read data files
require 'csv'

puts "Taxons seen with no common_name"

taxons_seen_without_common_name = Taxon.seen.select { | t | t.common_name == nil }

taxons_seen_without_common_name.each do | t |
	puts "%d %s\n" % [ t.id, t.latin_name ]
	t.sightings.each do | sighting |
		puts "      %d" % sighting.id
	end
end

puts "Sightings with no latin_name"

sightings_without_latin_name = Sighting.find(:all).select { | s | s.taxon == nil }
sightings_without_latin_name.each do | s | puts "%d %s\n" % [s.id, s.taxon_latin_name] end
