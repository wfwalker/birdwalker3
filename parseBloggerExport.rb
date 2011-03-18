#!/usr/bin/env ruby

require '/Users/wilwalke/rubyOnRails/birdwalker3/config/boot'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"
require "mysql"                             
require 'optparse'     

require 'net/http'
require 'uri'

include REXML

require 'readline'       

xmp_file = File.new("blog-02-14-2011.xml", "r")
xmp_document = Document.new(xmp_file.read)

entries = []

XPath.each(xmp_document, "/feed/entry[author/name/text()='Bill Walker']") { | thing |
  entry = {}
  entry['title'] = thing.get_elements("title")[0].text()
  entry['date'] = Date.strptime(thing.get_elements("published")[0].text())
  entry['kind'] = thing.get_elements("category")[0].attribute("term").to_s().split('#')[1]
  if thing.get_elements("content")[0].text() then
    entry['content'] = thing.get_elements("content")[0].text()
  end
  entries << entry
}

entries.each { | an_entry | print "%s %s %s\n\n%s\n\n" % [an_entry["kind"], an_entry["date"], an_entry["title"], an_entry["content"]] }
