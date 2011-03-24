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

# aCollection = Trip.find_by_id(733).sightings

#aCollection = Sighting.find_by_sql("SELECT DISTINCT sightings.* FROM trips, sightings
#       WHERE sightings.exclude!=1 AND sightings.trip_id=trips.id AND Year(trips.date)=2002 AND Month(trips.date)<4 AND Month(trips.date)>0")

aCollection = Sighting.find_by_sql("SELECT DISTINCT sightings.* FROM trips, sightings
       WHERE sightings.exclude!=1 AND sightings.trip_id=trips.id AND Year(trips.date)=1995")

rows = aCollection.collect { | sighting | sighting.to_ebird_record_format() }

rows.each do | row |
  puts row.join(',')
end