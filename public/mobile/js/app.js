

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
  if (panelName != '#countyDetailContainer')   $('#countyDetailContainer').hide();
  if (panelName != '#homeContainer')           $('#homeContainer').hide();
  if (panelName != '#taxonDetailContainer')    $('#taxonDetailContainer').hide();
  if (panelName != '#taxonIndexContainer')     $('#taxonIndexContainer').hide();

  stopSpinning();
  $(panelName).show();
}

function showPhotos(inPhotoData, inPhotoID)
{
  if (inPhotoData[0]) {
    $('#' + inPhotoID).append(render('photo-carousel', {photos: inPhotoData}));
  }
}

function showHome()
{
  $('#homeContainer').empty();    
  startSpinning();            

  $.ajax({
    type: 'GET',
    url: '/taxons/bird_of_the_week.json',
    dataType: 'json',
    success: function(data){
      var taxon = data[0];

      $('#homeContainer').append(render('home', { birdOfTheWeek: taxon }));
      showPhotos(taxon.photos, 'birdOfTheWeekPhoto');
    },
    error: function(xhr, type, thrownError){
        alert('showHome Ajax error! ' + xhr.status + ' ' + thrownError);
    }
  });

  showPanel('#homeContainer');
}

function showTaxonIndex(inTaxonListURL)
{
    startSpinning();          

    $.ajax({
      type: 'GET',
      url: inTaxonListURL,
      dataType: 'json',
      success: function(data){
        $('#taxonIndexContainer').empty();
        $('#taxonIndexContainer').append(render('taxon-index', {allTaxonsSeen: data}));

        showPanel('#taxonIndexContainer');
      },
      error: function(xhr, type, thrownError){
        alert('showTaxonIndex Ajax error! ' + xhr.status + ' ' + thrownError);
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

        showPhotos(location.photos, 'locationPhoto');

        showPanel('#locationDetailContainer');
      },
      error: function(xhr, type, thrownError){
        alert('showLocationDetail Ajax error! ' + xhr.status + ' ' + thrownError);
      }
    });
}

function showCountyDetail(inCountyDetailURL)
{
    $.ajax({
      type: 'GET',
      url: inCountyDetailURL,
      dataType: 'json',
      success: function(data){
        var county = data[0];
        $('#countyDetailContainer').empty(); 
        $('#countyDetailContainer').append(render('county-detail', {county: county}));

        showPhotos(county.photos, 'countyPhoto');

        showPanel('#countyDetailContainer');
      },
      error: function(xhr, type, thrownError){
        alert('showCountyDetail Ajax error! ' + xhr.status + ' ' + thrownError);
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

        showPhotos(trip.photos, 'tripPhoto');

        showPanel('#tripDetailContainer');
      },
      error: function(xhr, type, thrownError){
        alert('tripDetailContainer Ajax error! ' + xhr.status + ' ' + thrownError);
      }
    });
}

function showTaxonDetail(inTaxonDetailURL)
{
  console.log("showTaxonDetail");
  
    $.ajax({
      type: 'GET',
      url: inTaxonDetailURL,
      dataType: 'json',
      success: function(data){
        var taxon = data[0];
        $('#taxonDetailContainer').empty();   
        $('#taxonDetailContainer').append(render('taxon-detail', { taxon: taxon }));

        showPhotos(taxon.photos, 'taxonPhoto');

        showPanel('#taxonDetailContainer');
      },
      error: function(xhr, type, thrownError){
        alert('showTaxonDetail Ajax error! ' + xhr.status + ' ' + thrownError)
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
  } else if (pagekind == 'county') {
    showCountyDetail('/counties/' + objectid + '.json');
  } else if (pagekind == 'taxon') {
    showTaxonDetail('/taxons/latin/' + objectid + '.json');
  } else if (pagekind == 'trip') {
    showTripDetail('/trips/' + objectid + '.json');
  } else if (pagekind == 'locationIndex') {
    showLocationIndex('/locations.json');
  } else if (pagekind == 'taxonIndex') {
    showTaxonIndex('/taxons.json');
  } else if (pagekind == 'tripIndex') {
    showTripIndex('/trips.json');
  } else if (pagekind == 'home') {
    showHome();
  }
});

showHome();
