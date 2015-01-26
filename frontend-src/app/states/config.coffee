angular.module('states').config ( $urlRouterProvider, $urlMatcherFactoryProvider, $locationProvider ) ->
	$locationProvider.html5Mode(true).hashPrefix('!')
	$urlRouterProvider.otherwise('/')
	$urlMatcherFactoryProvider.strictMode(false)