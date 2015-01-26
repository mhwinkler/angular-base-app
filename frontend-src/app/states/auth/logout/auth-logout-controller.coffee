angular.module('states.auth.logout').controller 'AuthLogoutController', 
	( $scope, $state, UserAuthToken ) ->
		
		# userAuthToken = UserAuthToken.model()
		# userAuthToken.email    = Session.get 'email'
		# userAuthToken.password = Session.get 'password'

		$scope.Session.logout()
		$state.go('home.index')