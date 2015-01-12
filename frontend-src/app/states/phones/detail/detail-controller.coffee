
angular.module('states.phones.detail').controller 'PhoneDetailCtrl', 
	($scope, $stateParams, Phone) ->
		$scope.phone = Phone.get {phoneId: $stateParams.phoneId}, (phone) ->
			$scope.mainImageUrl = phone.images[0]
	
		$scope.setImage = (imageUrl) ->
			$scope.mainImageUrl = imageUrl
	