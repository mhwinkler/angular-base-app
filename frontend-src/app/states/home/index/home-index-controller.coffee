angular.module('states.home.index').controller 'HomeIndexCtrl', 
	( $scope, $state, UserAuthToken ) ->
		class HomeIndexCtrl 

			constructor: ->
				@$scope = $scope
				
		return new HomeIndexCtrl()
