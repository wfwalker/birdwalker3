
// This uses require.js to structure javascript:
// http://requirejs.org/docs/api.html#define

define(function(require) {
    // Zepto provides nice js and DOM methods (very similar to jQuery,
    // and a lot smaller):
    // http://zeptojs.com/
    var $ = require('zepto');

    // Need to verify receipts? This library is included by default.
    // https://github.com/mozilla/receiptverifier
    // require('receiptverifier');

    // Want to install the app locally? This library hooks up the
    // installation button. See <button class="install-btn"> in
    // index.html
    // require('./install-button');

    // Write your app here.

    function showPhoto(inPhotoURL, inPhotoID)
    {
      $.ajax({
        type: 'GET',
        url: inPhotoURL,
        dataType: 'json',
        success: function(data){
          var photo = data[0];
          $('#' + inPhotoID).append('<img src=\'/images/photo/' + photo.image_filename + '\' />');
        },
        error: function(xhr, type, thrownError){
            alert('showPhoto Ajax error! ' + xhr.status + ' ' + thrownError);
        }
      });
    }

    function showHome()
    {
      $('#homeContainer').empty();                
      $('#homeContainer').append('<div class=\'hidden-phone\' style=\'padding-top: 60px\'></div>');
      $('#homeContainer').append('<p>Welcome to birdWalker, a website of birding photos and trip reports by Bill Walker and Mary Wisnewski, California birders based in Santa Clara County.</p>');

      $('#homeContainer').append('<h3>Bird of the Week</h3>');    
      $('#homeContainer').append('<div id=\'birdOfTheWeekPhoto\'> </div>');    
      $('#homeContainer').append('<div id=\'birdOfTheWeek\'> </div>');    

      $('#homeContainer').append('<div><a id=\'toLocationIndex\' href=\'#\'>Location List</a>');    

      $.ajax({
        type: 'GET',
        url: '/species/bird_of_the_week.json',
        dataType: 'json',
        success: function(data){
          var species = data[0];

          $('#birdOfTheWeek').append("The bird of the week is the " + species.common_name);
          showPhoto('/photos/' + species.photos[0].id + '.json', 'birdOfTheWeekPhoto');
        },
        error: function(xhr, type, thrownError){
            alert('showHome Ajax error! ' + xhr.status + ' ' + thrownError);
        }
      });

      $('#toLocationIndex').click(function (e) { e.preventDefault(); showLocationIndex('/locations.json'); } );

      $('#speciesDetailContainer').hide();
      $('#locationDetailContainer').hide();
      $('#locationIndexContainer').hide();
      $('#homeContainer').show();
    }

    function showLocationIndex(inLocationListURL)
    {
        $.ajax({
          type: 'GET',
          url: inLocationListURL,
          dataType: 'json',
          success: function(data){
            $('#locationIndexContainer').empty();            
            $('#locationIndexContainer').append('<div class=\'hidden-phone\' style=\'padding-top: 60px\'></div>');
            $('#locationIndexContainer').append('<h3>Locations</h3>');
            $('#locationIndexContainer').append('<ul id=\'locationIndex\' class=\'nav navlist\'>');
            for (var i = 0; i < data.length; i++){
                var location = data[i];

                $('#locationIndex').append('<li class=\'active\'><a href=\'#\' id=\'location' + location.id + '\'>' + location.name);
                $('#location' + location.id).click((function(id) {
                    return function (e) { e.preventDefault(); showLocationDetail('/locations/' + id + '.json'); }
                })(location.id));
            }

            $('#speciesDetailContainer').hide();
            $('#locationDetailContainer').hide();
            $('#homeContainer').hide();
            $('#locationIndexContainer').show();
          },
          error: function(xhr, type, thrownError){
            alert('showLocationIndex Ajax error! ' + xhr.status + ' ' + thrownError);
          }
        });
    }

    function showLocationDetail(inLocationDetailURL)
    {
        $.ajax({
          type: 'GET',
          url: inLocationDetailURL,
          dataType: 'json',
          success: function(data){
            var location = data[0];
            $('#locationDetailContainer').empty();            
            $('#locationDetailContainer').append('<div class=\'hidden-phone\' style=\'padding-top: 60px\'></div>');
            $('#locationDetailContainer').append('<h2>' + location.name + '</h2>');
            $('#locationDetailContainer').append('<div>' + location.notes + '</div>');
            $('#locationDetailContainer').append('<div>' + location.latitude + ', ' + location.longitude + '</div>');
            $('#locationDetailContainer').append('<h3>Species</h3>');
            $('#locationDetailContainer').append('<ul id=\'speciesList\' class=\'nav navlist\'>');

            for (var i = 0; i < location.species.length; i++){
                var species = location.species[i];

                $('#speciesList').append('<li class=\'active\'><a href=\'#\' id=\'species' + species.id + '\'>' + species.common_name);
                $('#species' + species.id).click((function(id) {
                    return function (e) { e.preventDefault(); showSpeciesDetail('/species/' + id + '.json'); }
                })(species.id));
            }

            $('#locationIndexContainer').hide();
            $('#speciesDetailContainer').hide();
            $('#homeContainer').hide();
            $('#locationDetailContainer').show();
          },
          error: function(xhr, type, thrownError){
            alert('showLocationDetail Ajax error! ' + xhr.status + ' ' + thrownError);
          }
        });
    }

    function showSpeciesDetail(inSpeciesDetailURL)
    {
        $.ajax({
          type: 'GET',
          url: inSpeciesDetailURL,
          dataType: 'json',
          success: function(data){
            var species = data[0];
            $('#speciesDetailContainer').empty();            
            $('#speciesDetailContainer').append('<div class=\'hidden-phone\' style=\'padding-top: 60px\'></div>');
            $('#speciesDetailContainer').append('<h2>' + species.common_name + '</h2>');
            $('#speciesDetailContainer').append('<div style=\'font-style: italic\'>' + species.latin_name + '</div>');
            $('#speciesDetailContainer').append('<div>' + species.notes + '</div>');
            $('#speciesDetailContainer').append('<div id=\'speciesPhoto\'></div>');
            $('#speciesDetailContainer').append('<h3>Locations</h3>');
            $('#speciesDetailContainer').append('<ul id=\'locationList\' class=\'nav navlist\'>');

            showPhoto('/photos/' + species.photos[0].id + '.json', 'speciesPhoto');

            for (var i = 0; i < species.locations.length; i++){
                var location = species.locations[i];
                $('#locationList').append('<li class=\'active\'><a href=\'#\' id=\'location' + location.id + '\'>' + location.name);
                $('#location' + location.id).click((function(id) {
                    return function (e) { e.preventDefault(); showLocationDetail('/locations/' + id + '.json'); }
                })(location.id));
            }

            $('#locationDetailContainer').hide();
            $('#locationIndexContainer').hide();
            $('#homeContainer').hide();
            $('#speciesDetailContainer').show();
          },
          error: function(xhr, type, thrownError){
            alert('showSpeciesDetail Ajax error! ' + xhr.status + ' ' + thrownError)
          }
        });
    }

    $('#homebutton').click(showHome);
    showHome();
});

