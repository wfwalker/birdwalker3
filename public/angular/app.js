angular.module('birdwalker', [])
	.config(['$routeProvider', function($routeProvider) {
    $routeProvider.
	    when('/home', {templateUrl: 'partials/home.html', controller: HomeCtrl}).
	    when('/trips', {templateUrl: 'partials/trip-list.html', controller: TripListCtrl}).
	    when('/trips/:tripId', {templateUrl: 'partials/trip-detail.html', controller: TripDetailCtrl}).
	    when('/trips/:tripId/edit', {templateUrl: 'partials/trip-edit.html', controller: TripEditCtrl}).
	    when('/locations', {templateUrl: 'partials/location-list.html', controller: LocationListCtrl}).
	    when('/locations/:locationId', {templateUrl: 'partials/location-detail.html', controller: LocationDetailCtrl}).
	    when('/locations/:locationId/edit', {templateUrl: 'partials/location-edit.html', controller: LocationEditCtrl}).
	    when('/taxons', {templateUrl: 'partials/taxon-list.html', controller: TaxonListCtrl}).
	    when('/taxons/:taxonId', {templateUrl: 'partials/taxon-detail.html', controller: TaxonDetailCtrl}).
	    when('/sightings/:sightingId', {templateUrl: 'partials/sighting-detail.html', controller: SightingDetailCtrl}).
	    when('/sightings/:sightingId/edit', {templateUrl: 'partials/sighting-edit.html', controller: SightingEditCtrl}).
	    otherwise({redirectTo: '/home'});
}]);

function setPageTitle(inString) {
	document.title = 'birdWalker | ' + inString;
}

function HomeCtrl($scope, $http) {
	$scope.loading = true;
	setPageTitle('Home');


  	$http.get('/bird_walker/index.json').success(function(data) {
		$scope.home = data;
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function TripListCtrl($scope, $http) {
	$scope.loading = true;
	setPageTitle('Trips');

  	$http.get('/trips.json').success(function(data) {
		$scope.trips = data;
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function TripDetailCtrl($scope, $routeParams, $http) {
	$scope.tripId = $routeParams.tripId;
	$scope.loading = true;

	$('#editlink').attr('href', '#/trips/' + $scope.tripId + '/edit');

	$http.get('/trips/' + $scope.tripId + '.json').success(function(data) {
		$scope.trip = data[0];
		$scope.loading = false;
		setPageTitle($scope.trip.name);

		var minLat = 360; minLong = 360; maxLat = -360; maxLong = -360; var count = 0;
		var markerList = "";

		$scope.trip.locations.forEach(function(location) {
			if (location.latitude) {
				minLat = Math.min(minLat, location.latitude);
				minLong = Math.min(minLong, location.longitude);
				maxLat = Math.max(maxLat, location.latitude);
				maxLong = Math.max(maxLong, location.longitude);

				if (count < 50) {
					markerList += ("|" + location.latitude + "," + location.longitude);
				}
				count += 1;
			}
		});

		$scope.mapData = {
			latitude: (minLat + maxLat) / 2.0,
			longitude: (minLong + maxLong) / 2.0,
			markerList: markerList
		};
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});
}

function TripEditCtrl($scope, $routeParams, $http, $location) {
	$scope.tripId = $routeParams.tripId;
	$scope.loading = true;

	$('#editlink').attr('href', '#/trips/' + $scope.tripId + '/edit');

	$http.get('/trips/' + $scope.tripId + '/edit.json').success(function(data) {
		$scope.trip = data[0];
		setPageTitle($scope.trip.name);
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});

	$scope.submit = function() {
		$scope.loading = true;

		$http.put('/trips/' + $scope.tripId, $scope.trip).success(function(data) {
			// TODO how to send the rest of the form data
			$scope.loading = false;
			$location.path('/trips/' + $scope.tripId)
		}).error(function(data) {
			alert("FAIL");
			$scope.loading = false;
		});			
	};
}


function LocationListCtrl($scope, $http) {
	$scope.loading = true;
	setPageTitle('Birding Map');

	$http.get('/locations.json').success(function(data) {
		$scope.locations = data;
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function LocationDetailCtrl($scope, $routeParams, $http) {
	$scope.locationId = $routeParams.locationId;
	$scope.loading = true;

	$('#editlink').attr('href', '#/locations/' + $scope.locationId + '/edit');

	$http.get('/locations/' + $scope.locationId + '.json').success(function(data) {
		$scope.location = data[0];
		setPageTitle($scope.location.name);
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function LocationEditCtrl($scope, $routeParams, $http) {
	$scope.locationId = $routeParams.locationId;
	$scope.loading = true;
	setPageTitle('Birding Map');

	$('#editlink').attr('href', '#/locations/' + $scope.locationId + '/edit');

	$http.get('/locations/' + $scope.locationId + '/edit.json').success(function(data) {
		$scope.location = data['location'];
		$scope.allCounties = data['all_counties'];
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function TaxonListCtrl($scope, $http) {
	$scope.loading = true;
	setPageTitle('Life List');

	$http.get('/taxons.json').success(function(data) {
		$scope.taxons = data;
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function TaxonDetailCtrl($scope, $routeParams, $http) {
	$scope.taxonId = $routeParams.taxonId;
	$scope.loading = true;

	$http.get('/taxons/' + $scope.taxonId + '.json').success(function(data) {
		$scope.taxon = data[0];
		$scope.loading = false;

		setPageTitle($scope.taxon.common_name);

		var minLat = 360; minLong = 360; maxLat = -360; maxLong = -360; var count = 0;
		var markerList = "";

		$scope.taxon.locations.forEach(function(location) {
			if (location.latitude) {
				minLat = Math.min(minLat, location.latitude);
				minLong = Math.min(minLong, location.longitude);
				maxLat = Math.max(maxLat, location.latitude);
				maxLong = Math.max(maxLong, location.longitude);

				if (count < 50) {
					markerList += ("|" + location.latitude + "," + location.longitude);
				}
				count += 1;
			}
		});

		$scope.mapData = {
			latitude: (minLat + maxLat) / 2.0,
			longitude: (minLong + maxLong) / 2.0,
			markerList: markerList
		};

		var lastDate = new Date($scope.taxon.sightings[$scope.taxon.sightings.length - 1].trip.date);
		var firstDate = new Date($scope.taxon.sightings[0].trip.date);

		$scope.sightingYearSpan = lastDate.getYear() - firstDate.getYear();
		$scope.sightingAnnualRate = Math.round(1.0 * $scope.taxon.sightings.length / $scope.sightingYearSpan);
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    

}

function SightingDetailCtrl($scope, $routeParams, $http) {
	$scope.sightingId = $routeParams.sightingId;
	$scope.loading = true;

	$('#editlink').attr('href', '#/sightings/' + $scope.sightingId + '/edit');	

	$http.get('/sightings/' + $scope.sightingId + '.json').success(function(data) {
		$scope.sighting = data[0];
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

function SightingEditCtrl($scope, $routeParams, $http) {
	$scope.sightingId = $routeParams.sightingId;
	$scope.loading = true;

	$http.get('/sightings/' + $scope.sightingId + '/edit.json').success(function(data) {
		$scope.sighting = data['sighting'];
		$scope.allTrips = data['all_trips'];
		$scope.allLocations = data['all_locations'];
		$scope.loading = false;
	}).error(function(data) {
		alert("FAIL");
		$scope.loading = false;
	});    
}

// $(document).ready(function(){ 
// 	$('.ajax-typeahead').typeahead({
// 	    source: function(query, process) {
// 	        return $.ajax({
// 	            url: $(this)[0].$element[0].dataset.link,
// 	            type: 'get',
// 	            data: {query: query},
// 	            dataType: 'json',
// 	            success: function(json) {
// 	                return typeof json.options == 'undefined' ? false : process(json.options);
// 	            }
// 	        });
// 	    }
// 	});
// });

