angular.module('states.phones.list').controller 'PhoneListCtrl', 
	($scope, Phone) ->
		console.debug '[states.phones.list.controller()]'
		console.debug 'another'
		$scope.phones    = Phone.query()
		$scope.orderProp = 'age'
