#!/usr/bin/env ruby

require File.expand_path('../config/boot', __FILE__)

# need CSV package to read data files
require 'csv'

puts "Clements-Shipman scientific name unification"

renames_text = File.read('./Shipman-Clements-renames.csv')
renames = CSV.parse(renames_text, :headers => true)
renameDictionary = {}
renames.each do |row|
  row = row.to_hash.with_indifferent_access
  renameDictionary[row['OLD LATIN'].downcase] = row
end

# -------------------------------

puts "loading CSV"
clements_text = File.read('./clements.csv')
clements = CSV.parse(clements_text, :headers => true)
clementsDictionary = {}

puts "delete all taxons"
Taxon.delete_all()

puts "insert taxons"
taxonCount = 0
clements.each do |row|
  row = row.to_hash.with_indifferent_access
  taxon_hash = { 'sort' => row['SORT'], 'category' => row['CATEGORY'], 'latin_name' => row['SCIENTIFIC NAME'], 'common_name' => row['ENGLISH NAME'], 'range' => row['RANGE'], 'order' => row['ORDER'], 'family' => row['FAMILY'] }
  Taxon.create!(taxon_hash)
  clementsDictionary[row['SCIENTIFIC NAME'].downcase] = row
  taxonCount = taxonCount + 1
  if (taxonCount % 1000 == 0)
    puts "%d taxons" % taxonCount
  end
end

# -------------------------------

matchCount = 0
brokenMatchCount = 0
renameGoCount = 0
renameNotDoneCount = 0
failCount = 0

Species.seen.each do |species|
  if renameDictionary[species.latin_name.downcase]
    renamedMatch = renameDictionary[species.latin_name.downcase]
    if renamedMatch["STATUS"] == "ready" and renamedMatch["OLD COMMON"] == species.common_name and renamedMatch["OLD LATIN"] == species.latin_name and renamedMatch["NEW LATIN"] != ""
      # puts "RENAME GO %s %s == %s %s" % [species.latin_name, species.common_name, renamedMatch["NEW LATIN"], renamedMatch["OLD COMMON"]]
      Sighting.update_all({:taxon_latin_name => renamedMatch["NEW LATIN"]}, {:species_id => species.id})
      Photo.update_all({:taxon_latin_name => renamedMatch["NEW LATIN"]}, {:species_id => species.id})
      Taxon.update_all({:abbreviation => species.abbreviation}, {:latin_name => renamedMatch["NEW LATIN"]})

      renameGoCount += 1
      renameDictionary[species.latin_name.downcase] = "REMOVED"
    else
      puts "RENAME NOT DONE (%d) %s %s == %s %s" % [species.sightings.count, species.latin_name, species.common_name, renamedMatch["NEW LATIN"], renamedMatch["OLD COMMON"]]
      renameDictionary[species.latin_name.downcase] = "REMOVED"
      renameNotDoneCount += 1
    end
  elsif Taxon.find_by_latin_name(species.latin_name)
    taxon = Taxon.find_by_latin_name(species.latin_name)
    if taxon.common_name.downcase == species.common_name.downcase and taxon.latin_name.downcase == species.latin_name.downcase then
      # puts "MATCH %s %s == %s %s" % [species.latin_name, species.common_name, clementsMatch["SCIENTIFIC NAME"], clementsMatch["ENGLISH NAME"]]
      Sighting.update_all({:taxon_latin_name => taxon.latin_name}, {:species_id => species.id})
      Photo.update_all({:taxon_latin_name => taxon.latin_name}, {:species_id => species.id})
      Taxon.update_all({:abbreviation => species.abbreviation}, {:latin_name => taxon.latin_name})
      matchCount += 1
    else
      # TODO: case-insensitive match!!
      puts "BROKEN (%d) %s %s == %s %s" % [species.sightings.count, species.latin_name, species.common_name, taxon.latin_name, taxon.common_name]
      brokenMatchCount += 1
    end
  else
    puts "FAIL (%d) %s %s" % [species.sightings.count, species.common_name, species.latin_name]
    failCount += 1
  end
end

puts "match %d broken %d rename go %d notdone %d fail %d" % [matchCount, brokenMatchCount, renameGoCount, renameNotDoneCount, failCount]

puts "UNUSED RENAMES"
renameDictionary.each_pair do |k, v|
  if v != 'REMOVED'
    puts k, v
  end
end

