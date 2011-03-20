#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"
include REXML

def get_XML_from_eBird(in_path, in_args)
  # construct URL
  query_strings = in_args.collect { |key, value| "%s=%s" % [key, value] }
  full_url_string = "http://ebird.org/ws1.1/%s?%s" % [in_path, query_strings.join('&')]

  # GET data
  url = URI.parse(full_url_string)
  req = Net::HTTP::Get.new(full_url_string)
  
  # parse XML
  xmlData = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
  Document.new(xmlData.body())
end

def parse_XML_as_ebird_sightings(in_XML)
  entries = []
  XPath.each(in_XML, "/response/result/sighting") { | sighting_xml |
    entry = {}
    entry['loc-name'] = sighting_xml.get_elements("loc-name")[0].text()
    entry['common-name'] = sighting_xml.get_elements("com-name")[0].text()
    entry['date'] = Date.strptime(sighting_xml.get_elements("obs-dt")[0].text())
    entries << entry
  }
  entries
end

location_id = $*

the_location = Location.find(location_id)[0]

puts the_location.name

ebirdXmlData = get_XML_from_eBird('data/obs/geo/recent', {'lng' => the_location.longitude, 'lat' => the_location.latitude, 'dist' => 5, 'back' => 5})
sightings = parse_XML_as_ebird_sightings(ebirdXmlData)

sightings.each { | a_sighting |
  puts "%s on %s at %s\n" % [a_sighting["common-name"], a_sighting["date"], a_sighting["loc-name"]]
}

