angular.module('birdwalker', [])
	.config(['$routeProvider', function($routeProvider) {
    $routeProvider.
	    when('/trips', {templateUrl: 'partials/trip-list.html', controller: TripListCtrl}).
	    when('/trips/:tripId', {templateUrl: 'partials/trip-detail.html', controller: TripDetailCtrl}).
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
	});    
}

