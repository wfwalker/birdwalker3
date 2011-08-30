#!/usr/bin/env ruby

require '/Users/walker/rubyOnRails/birdwalker3/config/boot'  

# we use ImageMagick and rmagick to scale and crop JPEGs
require 'RMagick'
include Magick

# we use mysql package to query local copy of birdwalker database
require "mysql"                                                  

# we use optparse to parse command-line options
require 'optparse'     

# we use readline to prompt for input
require 'readline'   

# -----------------------------------------------------------------------------------------------------    
                                   
class LocalBirdImage
  # some constants for places on the disk
  Birdwalker2_image_source_path = '/Users/walker/Photography/bw2imagesource'
  Birdwalker3_photo_path = '/Users/walker/rubyOnRails/birdwalker3/public/images/photo'
  Birdwalker3_thumb_path = '/Users/walker/rubyOnRails/birdwalker3/public/images/thumb'
  FlickrUP_path = '/Users/walker/Photography/flickrUP/'
                               
  Raw_file_roots = ['/Users/walker/Photography/February Backups/', '/Users/walker/Photography/February Backups/photos-', '/Volumes/Rhea Photo One/Photos/', '/Volumes/Rhea Photo One/Photos/photos-']
                        
  Label_path = "/*[local-name()='xmpmeta']/*[local-name()='RDF']/*[local-name()='Description']/*[local-name()='Label']"
  Location_path = "/*[local-name()='xmpmeta']/*[local-name()='RDF']/*[local-name()='Description']/*[local-name()='Location']"
  Date_path = "/*[local-name()='xmpmeta']/*[local-name()='RDF']/*[local-name()='Description']/*[local-name()='DateTimeOriginal']"

  attr_accessor :db_connection, :filename_root, :flickrup_file, :location_name, :species_common_name, :capture_date_string, :trip_id, :species_abbreviation, :species_id, :location_id
             
  def get_birdwalker_filename
    return @capture_date_string + '-' + @species_abbreviation + '-' + @filename_root + '.jpg'         
  end                   
  
  def get_master_jpeg_filename
    return Birdwalker2_image_source_path + '/' + get_birdwalker_filename()
  end
  
  def get_photo_jpeg_filename
    return Birdwalker3_photo_path + '/' + get_birdwalker_filename()
  end
  
  def get_thumb_jpeg_filename
    return Birdwalker3_thumb_path + '/' + get_birdwalker_filename()
  end  
                       
  def initialize_flickrup_image_list()
    # Go get the JPEG in the flickrUP folder, extract its capture date 
    flickrup_jpeg_path = LocalBirdImage::FlickrUP_path + @filename_root + '.jpg'

    if (File.exist?(flickrup_jpeg_path))
      @flickrup_image_list = ImageList.new(flickrup_jpeg_path)     
      return true
    else
      return false
    end
  end   
    
  def initialize(in_filename_root, in_db_connection)                
    @db_connection = in_db_connection                 
    @filename_root = in_filename_root
  end
end                               

# -----------------------------------------------------------------------------------------------------    

def prompt(prompt="> ")
  input = nil
  prompt += " " unless prompt =~ /\s$/
  loop do
    input = Readline.readline(prompt, true)
    break if input.length > 0
  end
  return input
end
                                             
def get_filename_roots_from_birdwalker3_photo_path(in_time_interval = 40000000.0)
  # scan the flickrup folder
  all_jpegs = Dir.glob(LocalBirdImage::Birdwalker3_photo_path + "/*.jpg")      
                               
  puts "Found %d images" % all_jpegs.length

  recent_jpegs = all_jpegs.select do |a_jpeg|
    Time.now - File.mtime(a_jpeg) < in_time_interval
  end

  puts "Found %d recent JPEGs" % recent_jpegs.length
  
  return recent_jpegs.collect do |a_file|        
    File.basename(a_file, ".jpg")
  end                          
end

# ################################
# This hash will hold all of the options
# parsed from the command-line by
# OptionParser.
options = {}        

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: photoMetadataGrabber.rb [options] filenameStem"

  # Define the options, and what they do
  options[:verbose] = false
  opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end         

# ###########################################################################################                       
# MAIN           

# PARSE ARGUMENTS 'parse!' method parses ARGV and removes any options found there, as well as any parameters
# for the options. What's left is the list of filenames
optparse.parse!         

# CONNECT to the local birdwalker DB; it would be best to connect to the remote one, but
# we'll use the local one for now
the_db_connection = Mysql.real_connect("localhost", "root", "", "HelloWorld_development")                 

# Candidate images
candidate_images = []
candidate_images.concat(ARGV)                      
candidate_images.concat(get_filename_roots_from_birdwalker3_photo_path())

# SCAN recent JPEGs in flickrUP folder                      
candidate_images.each do |filename_root|
  begin
  	an_image = LocalBirdImage.new(filename_root, the_db_connection)    
  	birdwalker3_JPEG = Magick::Image.read(LocalBirdImage::Birdwalker3_photo_path + "/" + filename_root + ".jpg").first
    # the get_exif_by_entry method returns in the format: [["Make", "Canon"]]      
    
    focalLength = eval(birdwalker3_JPEG.get_exif_by_entry('FocalLength')[0][1])
    fStop = eval("1.0*" + (birdwalker3_JPEG.get_exif_by_entry('FNumber')[0][1]))  
    shutterSpeed = eval("1.0*" + birdwalker3_JPEG.get_exif_by_entry('ExposureTime')[0][1])
    
    puts "%s -- %d X %d, %dmm, 1/%d sec at f%2.1f" % [filename_root, birdwalker3_JPEG.rows, birdwalker3_JPEG.columns, focalLength, (1.0/shutterSpeed), fStop]

  rescue StandardError => myStandardError
    $stderr.puts "\n\n--------------------------------------------------\n"
    $stderr.puts filename_root + " error: " + myStandardError
  end
end             

exit
