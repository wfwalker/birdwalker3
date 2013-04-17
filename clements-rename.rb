#!/usr/bin/env ruby

require File.expand_path('../config/boot', __FILE__)

# need CSV package to read data files
require 'csv'

def health_report
  taxon_count = Taxon.find(:all).count
  species_seen_count = Species.seen.count
  sightings_missing_taxon_count = Sighting.find_by_sql("SELECT * FROM sightings where sightings.taxon_latin_name IS NULL").count
  puts "taxons %d species seen %d sightings lacking taxon %d" % [taxon_count, species_seen_count, sightings_missing_taxon_count]
end

def read_renames
  renames_text = File.read('./Shipman-Clements-renames.csv')
  renames = CSV.parse(renames_text, :headers => true)
  renameDictionary = {}
  renames.each do |row|
    row = row.to_hash.with_indifferent_access
    renameDictionary[row['OLD LATIN'].downcase] = row
  end

  return renameDictionary
end

def populate_taxons_from_clements
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
end

def apply_renames(renameDictionary)
  matchCount = 0
  brokenMatchCount = 0
  renameGoCount = 0
  renameNotDoneCount = 0
  failCount = 0

  # For each species in the species table for which we have sightings
  Species.seen.each do |species|
    # if there is a (case-insensitive) rename instruction

    if renameDictionary[species.latin_name.downcase]
      renamedMatch = renameDictionary[species.latin_name.downcase]

      # if the rename is approved, and the rename looks complete
      if renamedMatch["STATUS"] == "ready" and renamedMatch["OLD COMMON"] == species.common_name and renamedMatch["OLD LATIN"] == species.latin_name and renamedMatch["NEW LATIN"] != ""
        # puts "RENAME GO %s %s == %s %s" % [species.latin_name, species.common_name, renamedMatch["NEW LATIN"], renamedMatch["OLD COMMON"]]

        # add the new latin_name to all affected sightings
        Sighting.update_all({:taxon_latin_name => renamedMatch["NEW LATIN"]}, {:species_id => species.id})
        # add the new latin_name to all affected photos 
        Photo.update_all({:taxon_latin_name => renamedMatch["NEW LATIN"]}, {:species_id => species.id})
        # copy over the corresponding abbreviation to the new taxon
        Taxon.update_all({:abbreviation => species.abbreviation}, {:latin_name => renamedMatch["NEW LATIN"]})

        # increment count of successful renames
        renameGoCount += 1

        # record the fact that the rename instruction was checked
        renameDictionary[species.latin_name.downcase] = "REMOVED"
      else
        # rename is not ready or fields are missing
        puts "RENAME NOT DONE (%d) %s %s == %s %s" % [species.sightings.count, species.latin_name, species.common_name, renamedMatch["NEW LATIN"], renamedMatch["OLD COMMON"]]
        # record the fact that the rename instruction was checked
        renameDictionary[species.latin_name.downcase] = "REMOVED"
        # increment count of unsuccessful renames
        renameNotDoneCount += 1
      end
    # there's no rename but there is a taxon that matches the species
    elsif Taxon.find_by_latin_name(species.latin_name)
      taxon = Taxon.find_by_latin_name(species.latin_name)

      # both latin and common names match, good to go
      if taxon.common_name.downcase != species.common_name.downcase then
        # there is a taxon for this species latin name, but the common names don't match
        puts "NOTE common name upgrade %s != %s" % [species.common_name, taxon.common_name]
        brokenMatchCount += 1
      else
        # increment count of successful matches
        matchCount += 1
      end

      # add the new latin_name to all affected sightings
      Sighting.update_all({:taxon_latin_name => taxon.latin_name}, {:species_id => species.id})
      # add the new latin_name to all affected photos 
      Photo.update_all({:taxon_latin_name => taxon.latin_name}, {:species_id => species.id})
      # copy over the corresponding abbreviation to the new taxon
      Taxon.update_all({:abbreviation => species.abbreviation}, {:latin_name => taxon.latin_name})

    # there's no rename for this species, nor a taxon that matches by latin name
    else
      puts "FAIL (%d) %s %s" % [species.sightings.count, species.common_name, species.latin_name]
      puts "adding note to %d trips that have this FAIL" % species.trips.count
      species.trips.each do | a_trip |
        revised_notes = a_trip.notes + (" Also saw %s" % species.common_name)
        a_trip.notes = revised_notes
        a_trip.save()
      end
      species.sightings.destroy_all()
      failCount += 1
    end
  end

  puts "match %d broken %d rename go %d notdone %d fail %d" % [matchCount, brokenMatchCount, renameGoCount, renameNotDoneCount, failCount]

  if renameDictionary.keys.count > 0 then
    puts "UNUSED RENAMES"
    renameDictionary.each_pair do |k, v|
      if v != 'REMOVED'
        puts k, v
      end
    end  
  end
end


# -------------------------------
puts "Clements-Shipman scientific name unification"

health_report();
renameDictionary = read_renames();
populate_taxons_from_clements();
health_report();
apply_renames(renameDictionary);
health_report();

# -------------------------------


