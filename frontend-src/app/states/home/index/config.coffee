angular.module('states.home.index').config ( $stateProvider ) ->
	$stateProvider.state 'home.index', 
		url   : ''
		views : 
			main : 
				templateUrl : 'states/home/index/main.html'
				controller  : 'HomeIndexCtrl'
