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

aTrip = Trip.find_by_id(734)

rows = aTrip.sightings.collect { | sighting | sighting.to_ebird_record_format() }

rows.each do | row |
  puts row.join(',')
end