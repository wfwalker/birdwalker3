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

ebirdXmlData = get_XML_from_eBird('data/obs/geo/recent', {'lng' => '-76.51', 'lat' => '42.46'})
ebirdXmlData.write($stdout, 3)