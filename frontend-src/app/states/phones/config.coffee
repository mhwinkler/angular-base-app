
angular.module('states.phones').config ( $stateProvider ) ->

	$stateProvider.state 'phones', 
		abstract    : true
		url         : '/phones'
		templateUrl : window.abaTemplatePath + '/layouts/default.html'

