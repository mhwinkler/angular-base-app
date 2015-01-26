angular.module('states.auth.login').controller 'AuthLoginController', 
	( $scope, UserAuthToken, Session ) ->
		
		userAuthToken = UserAuthToken.model()
		userAuthToken.email    = Session.get 'email'
		userAuthToken.password = Session.get 'password'

		$scope.userAuthToken = userAuthToken
		
		# $scope.login = ( email, password ) ->
		# 	console.log email
		# 	console.log password
		# 	console.log $scope.userAuthToken.email
		# 	console.log $scope.userAuthToken.password