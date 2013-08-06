angular.module('birdwalker', [])
	.config(['$routeProvider', function($routeProvider) {
    $routeProvider.
	    when('/trips', {templateUrl: 'partials/trip-list.html', controller: TripListCtrl}).
	    when('/trips/:tripId', {templateUrl: 'partials/trip-detail.html', controller: TripDetailCtrl}).
	    when('/trips/:tripId/edit', {templateUrl: 'partials/trip-edit.html', controller: TripDetailCtrl}).
	    when('/locations', {templateUrl: 'partials/location-list.html', controller: LocationListCtrl}).
	    when('/locations/:locationId', {templateUrl: 'partials/location-detail.html', controller: LocationDetailCtrl}).
	    when('/taxons', {templateUrl: 'partials/taxon-list.html', controller: TaxonListCtrl}).
	    when('/taxons/:taxonId', {templateUrl: 'partials/taxon-detail.html', controller: TaxonDetailCtrl}).
	    otherwise({redirectTo: '/trips'});
}]);

function TripListCtrl($scope, $http) {
	$scope.loading = true;

  	$http.get('/trips.json').success(function(data) {
		$scope.trips = data;
		$scope.loading = false;
	});    
}

function TripDetailCtrl($scope, $routeParams, $http) {
	$scope.tripId = $routeParams.tripId;
	$scope.loading = true;

	$http.get('/trips/' + $scope.tripId + '.json').success(function(data) {
		$scope.trip = data[0];
		$scope.loading = false;
	});

	$scope.submit = function() {
		console.log("submitted " + $scope.trip.date);
	};
}

function LocationListCtrl($scope, $http) {
	$scope.loading = true;

	$http.get('/locations.json').success(function(data) {
		$scope.locations = data;
		$scope.loading = false;
	});    
}

function LocationDetailCtrl($scope, $routeParams, $http) {
	$scope.locationId = $routeParams.locationId;
	$scope.loading = true;

	$http.get('/locations/' + $scope.locationId + '.json').success(function(data) {
		$scope.location = data[0];
		$scope.loading = false;
	});    
}

function TaxonListCtrl($scope, $http) {
	$scope.loading = true;

	$http.get('/taxons.json').success(function(data) {
		$scope.taxons = data;
		$scope.loading = false;
	});    
}

function TaxonDetailCtrl($scope, $routeParams, $http) {
	$scope.taxonId = $routeParams.taxonId;
	$scope.loading = true;

	$http.get('/taxons/' + $scope.taxonId + '.json').success(function(data) {
		$scope.taxon = data[0];
		$scope.loading = false;

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
	});    

}

