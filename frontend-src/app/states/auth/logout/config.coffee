angular.module('states.auth.logout').config ( $stateProvider ) ->
	
	$stateProvider.state 'auth.logout', 
		url   : '/logout'
		views : 
			main : 
				# templateUrl : 'states/auth/logout/main.html'
				controller  : 'AuthLogoutController'
