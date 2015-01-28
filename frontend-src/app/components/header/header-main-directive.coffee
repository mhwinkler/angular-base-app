class HeaderMainController 

	constructor: ( $scope, $state, Session ) ->
		@$scope = $scope
		@$scope.Session = Session
		return @

angular.module('components.header').directive 'headerMain', ( mBaseDirective ) ->

	class headerMain extends mBaseDirective

		restrict    : 'A'
		templateUrl : 'components/header/header-main.html'
		scope       : {}

		constructor: ->
			super
			@controller = HeaderMainController 
			@controller.$inject = [ '$scope', '$state', 'Session' ]

	return new headerMain()