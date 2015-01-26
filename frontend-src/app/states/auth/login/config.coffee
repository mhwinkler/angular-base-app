angular.module('states.auth.login').config ( $stateProvider ) ->
	
	$stateProvider.state 'auth.login', 
		url   : '/login'
		views : 
			main : 
				templateUrl : 'states/auth/login/main.html'
				controller  : 'AuthLoginController'
