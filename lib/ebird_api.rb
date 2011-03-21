# Bill Walker's eBird API proxy

require 'net/http'
require 'uri'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"

class EBird
  # sample usage: EBird.get_XML('data/obs/geo/recent', {'lng' => the_location.longitude, 'lat' => the_location.latitude, 'dist' => 5, 'back' => 5})
  #
  def EBird.get_XML(in_path, in_args)
    # construct URL
    query_strings = in_args.collect { |key, value| "%s=%s" % [key, value] }
    full_url_string = "http://ebird.org/ws1.1/%s?%s" % [in_path, query_strings.join('&')]

    # GET data
    url = URI.parse(full_url_string)
    req = Net::HTTP::Get.new(full_url_string)
  
    # parse XML
    xmlData = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    REXML::Document.new(xmlData.body())
  end

  def EBird.parse_XML_as_sightings(in_XML)
    entries = []
    REXML::XPath.each(in_XML, "/response/result/sighting") { | sighting_xml |
      entry = {}
      entry['location-name'] = sighting_xml.get_elements("loc-name")[0].text()
      entry['common-name'] = sighting_xml.get_elements("com-name")[0].text()
      entry['date'] = Date.strptime(sighting_xml.get_elements("obs-dt")[0].text())
      entries << entry
    }
    entries
  end
end