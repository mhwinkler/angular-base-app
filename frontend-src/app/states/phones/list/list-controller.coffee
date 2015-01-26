angular.module('states.phones.list').controller 'PhoneListCtrl', 
	( $scope, $state, Session, Phone, Car ) ->
		if Session.isGuest
			$state.go 'home.index'

		console.debug '[states.phones.list.controller()]'
		console.debug 'another'

		# $scope.phone     = Phone.model()
		$scope.phones    = Phone.query()
		# $scope.cars      = Car.test()
		# $scope.phones = Phone.$search()
		$scope.orderProp = 'age'
