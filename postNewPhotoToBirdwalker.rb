#!/usr/bin/env ruby

require 'net/http'
require 'uri'

# LOGIN
url = URI.parse('http://localhost:3000/bird_walker/login')
req = Net::HTTP::Post.new(url.path)
req.set_form_data({'username' => 'walker', 'password' => 'nostril'})
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
puts res

theCookie = res.get_fields("set-cookie")[0].split('; ',2)[0]
puts "MOOO " + theCookie

url = URI.parse('http://localhost:3000/photos')
req = Net::HTTP::Post.new(url.path)
req.add_field 'Cookie', theCookie
req.set_form_data({'photo[location_id]'=>'101', 'photo[species_id]'=>'11062010100', 'photo[trip_id]' => '726', 'photo[original_filename]'=>'testing', 'photo[rating]' => '5'})
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }


#res = Net::HTTP.post_form(URI.parse(), {'location_id'=>'101', 'species_id'=>'11062010100', 'trip_id' => '726', 'original_filename'=>'testing', 'rating' => '5'})

puts res