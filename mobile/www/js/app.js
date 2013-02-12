
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

    // need this for decent date formatting
    require('date');

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
      if (panelName != '#tripDetailContainer')     $('#tripDetailContainer').hide();
      if (panelName != '#tripIndexContainer')      $('#tripIndexContainer').hide();
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
          $('#' + inPhotoID).append(render('img-tag', {photo: photo}));
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

            showPanel('#speciesIndexContainer');
          },
          error: function(xhr, type, thrownError){
            alert('showLSpeciesIndex Ajax error! ' + xhr.status + ' ' + thrownError);
            stopSpinning();
          }
        });
    }

    function showTripIndex(inTripListURL)
    {
        startSpinning();          

        $.ajax({
          type: 'GET',
          url: inTripListURL,
          dataType: 'json',
          success: function(data){
            $('#tripIndexContainer').empty();
            $('#tripIndexContainer').append(render('trip-index', {trips: data}));

            showPanel('#tripIndexContainer');
          },
          error: function(xhr, type, thrownError){
            alert('tripIndexContainer Ajax error! ' + xhr.status + ' ' + thrownError);
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

            showPanel('#locationDetailContainer');
          },
          error: function(xhr, type, thrownError){
            alert('showLocationDetail Ajax error! ' + xhr.status + ' ' + thrownError);
          }
        });
    }

    function showTripDetail(inTripDetailURL)
    {
        $.ajax({
          type: 'GET',
          url: inTripDetailURL,
          dataType: 'json',
          success: function(data){
            var trip = data[0];
            $('#tripDetailContainer').empty(); 
            $('#tripDetailContainer').append(render('trip-detail', {trip: trip}));

            showPanel('#tripDetailContainer');
          },
          error: function(xhr, type, thrownError){
            alert('tripDetailContainer Ajax error! ' + xhr.status + ' ' + thrownError);
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

            showPanel('#speciesDetailContainer');
          },
          error: function(xhr, type, thrownError){
            alert('showSpeciesDetail Ajax error! ' + xhr.status + ' ' + thrownError)
          }
        });
    }

    $(document).on("click", "a", function(e) {
      e.preventDefault();
      
      var pagekind = $(this).attr('data-pagekind');
      var objectid = $(this).attr('data-objectid');

      console.log("click " + pagekind + " " + objectid);

      if (pagekind == 'location') {
        showLocationDetail('/locations/' + objectid + '.json');
      } else if (pagekind == 'species') {
        showSpeciesDetail('/species/' + objectid + '.json');
      } else if (pagekind == 'trip') {
        showTripDetail('/trips/' + objectid + '.json');
      } else if (pagekind == 'locationIndex') {
        showLocationIndex('/locations.json');
      } else if (pagekind == 'speciesIndex') {
        showSpeciesIndex('/species.json');
      } else if (pagekind == 'tripIndex') {
        showTripIndex('/trips.json');
      } else if (pagekind == 'home') {
        showHome();
      }
    });

    showHome();
});

