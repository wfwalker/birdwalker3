function DeckCtrl($scope, $http) {
}

function TripListCtrl($scope, $http) {
	$http.get('/trips.json').success(function(data) {
		$scope.trips = data;
	});    

	$scope.tripDetailView = document.querySelector("#tripdetail");

	$scope.showTripDetail = function() {
		console.log("show trip detail " + this.trip.name);

		$http.get('/trips/' + this.trip.id + '.json').success(function(data) {
			$scope.$parent.detailTrip = data[0];
			$scope.tripDetailView.show();
		});    
	}
}

function LocationListCtrl($scope, $http) {
	$http.get('/locations.json').success(function(data) {
		$scope.locations = data;
	});    
}

function TaxonListCtrl($scope, $http) {
	$http.get('/taxons.json').success(function(data) {
		$scope.taxons = data;
	});    
}

window.addEventListener('DOMComponentsLoaded', function() {
	console.log('wiring up back button');

    var deck = document.querySelector('x-deck');

    document.body.addEventListener('click', function(e) {
    	console.log("listener fired");
    	
    	// TODO fix this horrible kludge
        if (e.target.parentElement.parentElement.classList.contains('back')) {
	    	console.log("going back");
            deck.historyBack();
        }
    })
});