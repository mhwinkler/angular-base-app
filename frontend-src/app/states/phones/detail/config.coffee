angular.module('states.phones.detail').config ( $stateProvider ) ->
	$stateProvider.state 'phones.detail', 
		url   : '/:phoneId'
		views : 
			main : 
				templateUrl : window.abaTemplatePath + '/states/phones/detail/main.html'
				controller  : 'PhoneDetailCtrl'
				
			
