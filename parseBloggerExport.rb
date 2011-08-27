#!/usr/bin/env ruby

require '/Users/walker/rubyOnRails/birdwalker3/config/boot'
require "rexml/document"
require "rexml/element"
require "rexml/xmldecl"
require "rexml/text"
require "mysql"                             
require 'optparse'     

require 'net/http'
require 'uri'

include REXML  


def fixup_content(content_string)                  
  # http://www.spflrc.org/~walker/tripdetail.php?view=&tripid=431        
  # http://www.spflrc.org/~walker/photodetail.php?id=9506
  # http://www.spflrc.org/~walker/tripdetail.php?view=photo&tripid=431
  # http://www.spflrc.org/~walker/index.php
  content_string.gsub('http://www.spflrc.org/~walker/tripdetail.php?id=', '/trips/')
end
                    
# Parse the Blogspot export file

xmp_file = File.new("blog-03-23-2011.xml", "r")
xmp_document = Document.new(xmp_file.read)

# extract title, date, kind, and content into hashtable; create array of such hashtables
entries = []

XPath.each(xmp_document, "/feed/entry[author/name/text()='Bill Walker']") { | entry_xml |
  entry = {}
  entry['title'] = entry_xml.get_elements("title")[0].text()
  entry['date'] = Date.strptime(entry_xml.get_elements("published")[0].text())
  entry['kind'] = entry_xml.get_elements("category")[0].attribute("term").to_s().split('#')[1]
  if entry_xml.get_elements("content")[0].text() then
    entry['content'] = entry_xml.get_elements("content")[0].text()
  end
  entries << entry
}                          
                                                                                        
# pull out just the content entries
content_entries = entries.select { | an_entry | an_entry["kind"] == 'post' }
                                   
# find all the existing trips and their dates
all_trips = Trip.find(:all, :order => "date DESC")    

all_trip_by_date = {}

all_trips.each { | a_trip |
  all_trip_by_date[a_trip.date] = a_trip
}
                                             
                                                                      
# TODO: what if it's always the next day, not the current day
# TODO: links to flickr probably not good?

content_entries.each { | an_entry| 
  if (all_trip_by_date.include?(an_entry["date"]))  
    # TODO: if there is already a trip on that date, append these notes?
    existing_trip = all_trip_by_date[an_entry["date"]]
    print "EXISTING %s TRIP %s HAS SAME DATE AS %s %s\n" % [existing_trip.date, existing_trip.name, an_entry["date"], an_entry["title"]]    
  else
    print "%s %s %s\n" % [an_entry["kind"], an_entry["date"], an_entry["title"]] 
    new_post = Post.new
    new_post.title = an_entry['title']
    new_post.content = fixup_content(an_entry["content"])
    new_post.date = an_entry["date"]
    new_post.save
  end
}