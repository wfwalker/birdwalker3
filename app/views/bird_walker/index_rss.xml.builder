xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
   xml.channel do
     xml.title "birdWalker"    
     xml.link url_for(:only_path => false, :controller => 'bird_walker', :action => 'index')
     xml.description "Mary and Bill's birding field notes and photos"

     xml.language "en-US"
     xml.generator "birdWalker"
                        
     if (@bird_of_the_week != nil)
       photo_of_the_week = @bird_of_the_week.photos.this_week[0]
       link_to_bird_of_the_week = link_to @bird_of_the_week.common_name, :only_path => false, :controller => 'species', :action => 'show', :id => @bird_of_the_week
       thumb = link_to photo_of_the_week.thumb(@http_host), :only_path => false, :controller => 'photos', :id => photo_of_the_week, :action => 'show'
       photo_date = nice_date(photo_of_the_week.trip.date)
       photo_location = photo_of_the_week.location.name
       
       xml.item do
         xml.title       "Bird of the Week (week " + Date.today.cweek.to_s + ")"
         xml.pubDate     Date.today
         xml.link        taxon_latin_name_path(:only_path => false, :id => @bird_of_the_week)
         xml.description "This week's Bird of the Week is the #{ link_to_bird_of_the_week }. " +
                         "<p> #{ thumb } </p>" +
                         "Photographed #{ photo_date } at #{ photo_location }"
         xml.guid        'bird_of_the_week_' + Date.today.year.to_s + '_' + Date.today.cweek.to_s
       end                         
     end
     
    @recent_trips.each do |trip|
      xml.item do
        if (trip.notes && trip.notes.length >= 1)
          description_text = trip.notes
        elsif (trip.locations.size > 1)
          first_location = trip.locations[0]
          description_text = "We observed #{ trip.species.size } species at #{ trip.locations.size } different locations in #{ first_location.county.name } County, #{ first_location.county.state.abbreviation }"
        else
          location = trip.locations[0]
          description_text = "We observed #{ trip.species.size } species at #{ location.name } in #{ location.county.name } County, #{ location.county.state.abbreviation }"
        end
        
        description_thumbs = ""
        for photo in trip.photos do
          description_thumbs += link_to photo.thumb(@http_host), :only_path => false, :controller => 'photos', :id => photo, :action => 'show'
        end
        
        xml.title       "Trip Report: " + trip.name
        xml.pubDate     trip.date
        xml.link        url_for(:only_path => false, :controller => 'trips', :action => 'show', :id => trip.id)
        xml.guid        url_for(:only_path => false, :controller => 'trips', :action => 'show', :id => trip.id)
        xml.description "<p>" + description_thumbs + "</p>" + description_text
      end
    end 
   end
 end