
// This uses require.js to structure javascript:
// http://requirejs.org/docs/api.html#define

define(function(require) {

    // Zepto provides nice js and DOM methods (very similar to jQuery,
    // and a lot smaller): http://zeptojs.com/

    // var $ = require('zepto');
    require('jquery.min');

    // need bootstrap-collapse plugin
    require('bootstrap.min');

    // trying out underscore
    require('underscore-min');

    // Need to verify receipts? This library is included by default.
    // https://github.com/mozilla/receiptverifier
    // require('receiptverifier');

    // Want to install the app locally? This library hooks up the
    // installation button. See <button class="install-btn"> in
    // index.html
    // require('./install-button');


    // simple code for putting underscore templates in files
    function render(tmpl_name, tmpl_data) {
        if ( !render.tmpl_cache ) { 
            render.tmpl_cache = {};
        }

        if ( ! render.tmpl_cache[tmpl_name] ) {
            var tmpl_dir = 'static/templates';
            var tmpl_url = tmpl_dir + '/' + tmpl_name + '.html';

            var tmpl_string;
            $.ajax({
                url: tmpl_url,
                method: 'GET',
                dataType: 'html',
                async: false,
                success: function(data) {
                    tmpl_string = data;
                }
            });

            render.tmpl_cache[tmpl_name] = _.template(tmpl_string);
        }

        return render.tmpl_cache[tmpl_name](tmpl_data);
    }

    // Write your app here.

    function startSpinning()
    {
      $('#spinner').show();
    }

    function stopSpinning()
    {
      $('#spinner').hide();
    }

    function showPanel(panelName)
    {
      if (panelName != '#locationDetailContainer') $('#locationDetailContainer').hide();
      if (panelName != '#locationIndexContainer')  $('#locationIndexContainer').hide();
      if (panelName != '#homeContainer')           $('#homeContainer').hide();
      if (panelName != '#speciesDetailContainer')  $('#speciesDetailContainer').hide();
      if (panelName != '#speciesIndexContainer')   $('#speciesIndexContainer').hide();

      stopSpinning();
      $(panelName).show();
    }

    function showPhoto(inPhotoURL, inPhotoID)
    {
      $.ajax({
        type: 'GET',
        url: inPhotoURL,
        dataType: 'json',
        success: function(data){
          var photo = data[0];
          $('#' + inPhotoID).append(render('img-tag', {imageURL: '/images/photo/' + photo.image_filename}));
        },
        error: function(xhr, type, thrownError){
            alert('showPhoto Ajax error! ' + xhr.status + ' ' + thrownError);
        }
      });
    }

    function showHome()
    {
      $('#homeContainer').empty();    
      startSpinning();            

      $.ajax({
        type: 'GET',
        url: '/species/bird_of_the_week.json',
        dataType: 'json',
        success: function(data){
          var species = data[0];

          $('#homeContainer').append(render('home', { birdOfTheWeek: species }));
          showPhoto('/photos/' + species.photos[0].id + '.json', 'birdOfTheWeekPhoto');

          $('#toLocationIndex').click(function (e) { e.preventDefault(); showLocationIndex('/locations.json'); } );
          $('#toSpeciesIndex').click(function (e) { e.preventDefault(); showSpeciesIndex('/species.json'); } );
        },
        error: function(xhr, type, thrownError){
            alert('showHome Ajax error! ' + xhr.status + ' ' + thrownError);
        }
      });

      showPanel('#homeContainer');
    }

    function showSpeciesIndex(inSpeciesListURL)
    {
        startSpinning();          

        $.ajax({
          type: 'GET',
          url: inSpeciesListURL,
          dataType: 'json',
          success: function(data){
            $('#speciesIndexContainer').empty();
            $('#speciesIndexContainer').append(render('species-index', {allSpeciesSeen: data}));

            _.each(data, function(species) {
                $('#species' + species.id).click((function(id) {
                    return function (e) { e.preventDefault(); showSpeciesDetail('/species/' + id + '.json'); }
                })(species.id));
            });

            showPanel('#speciesIndexContainer');
          },
          error: function(xhr, type, thrownError){
            alert('showLSpeciesIndex Ajax error! ' + xhr.status + ' ' + thrownError);
            stopSpinning();
          }
        });
    }

    function showLocationIndex(inLocationListURL)
    {
        startSpinning();          

        $.ajax({
          type: 'GET',
          url: inLocationListURL,
          dataType: 'json',
          success: function(data){
            $('#locationIndexContainer').empty();
            $('#locationIndexContainer').append(render('location-index', {locations: data}));

            _.each(data, function(location) {
              $('#location' + location.id).click((function(id) {
                  return function (e) { e.preventDefault(); showLocationDetail('/locations/' + id + '.json'); }
              })(location.id));
            });

            showPanel('#locationIndexContainer');
          },
          error: function(xhr, type, thrownError){
            alert('showLocationIndex Ajax error! ' + xhr.status + ' ' + thrownError);
            stopSpinning();
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
            $('#locationDetailContainer').append(render('location-detail', {location: location}));

            _.each(location.species, function(species) {
              $('#species' + species.id).click((function(id) {
                  return function (e) { e.preventDefault(); showSpeciesDetail('/species/' + id + '.json'); }
                })(species.id));
            });

            showPanel('#locationDetailContainer');
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
            $('#speciesDetailContainer').append(render('species-detail', { species: species }));

            if (species.photos[0]) {
              showPhoto('/photos/' + species.photos[0].id + '.json', 'speciesPhoto');
            }

            _.each(species.locations, function(location) {
                $('#location' + location.id).click((function(id) {
                    return function (e) { e.preventDefault(); showLocationDetail('/locations/' + id + '.json'); }
                })(location.id));
            });

            showPanel('#speciesDetailContainer');
          },
          error: function(xhr, type, thrownError){
            alert('showSpeciesDetail Ajax error! ' + xhr.status + ' ' + thrownError)
          }
        });
    }

    $('#homebutton').click(showHome);
    showHome();
});

