# Bill Walker's eBird API proxy

require 'net/http'
require 'uri'
require 'json'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"

class EBird
  # sample usage: EBird.get_XML('data/obs/geo/recent', {'lng' => the_location.longitude, 'lat' => the_location.latitude, 'dist' => 5, 'back' => 5})
  #
  def EBird.get_JSON(in_path, in_args)
    # construct URL
    query_strings = in_args.collect { |key, value| "%s=%s" % [key, value] }    
    query_strings << "fmt=json"
    full_url_string = "http://ebird.org/ws1.1/%s?%s" % [in_path, query_strings.join('&')]

    # GET data
    url = URI.parse(full_url_string)
    req = Net::HTTP::Get.new(full_url_string)
           
    # parse JSON
    jsonData = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }  
    ebirdData = jsonData.body()

    parsedEbirdData = JSON.parse(ebirdData)
    
    if ! ebirdData or ebirdData.include?("errorCode"):
      raise RuntimeError, "Exception from eBird: %s" % ebirdData
    end
    
    return parsedEbirdData
  end
end