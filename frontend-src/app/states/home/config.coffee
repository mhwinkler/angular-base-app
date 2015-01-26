angular.module('states.home').config ( $stateProvider ) ->

	$stateProvider.state 'home', 
		abstract    : true
		url         : '/'
		templateUrl : 'layouts/default.html'

