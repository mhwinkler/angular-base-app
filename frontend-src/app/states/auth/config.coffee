
angular.module('states.auth').config ( $stateProvider ) ->

	$stateProvider.state 'auth', 
		abstract    : true
		url         : '/auth'
		templateUrl : 'layouts/default.html'

