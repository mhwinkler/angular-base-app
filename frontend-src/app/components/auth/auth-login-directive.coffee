class AuthLoginController 

	constructor: ( $scope, $state, Session, UserAuthToken ) ->
		@$scope = $scope
		@$scope.model = UserAuthToken.model()
		@$scope.Session = Session

		@$state = $state
		
		@$scope.login = @login
		return @

	login: =>
		# @$scope.model.email    = @$scope.username
		# @$scope.model.password = @$scope.password
		@$scope.model.save( =>
			@$scope.Session.isGuest = false
			@$scope.Session.set 'email', @$scope.model.email
			@$scope.Session.set 'access_token', @$scope.model.access_token
			if @$state.includes('auth')
				@$state.go 'phones.list'
			# console.log @$scope.Session
		, =>
			# console.log @$scope.model._validationErrors
			angular.forEach @$scope.model._validationErrors, ( errors, field ) =>
				for error in errors
					@$scope.authLoginForm[field]?.$dirty = true
					@$scope.authLoginForm[field]?.$setValidity error, false
		)

		console.log @$scope.model.email
		console.log @$scope.model.password

angular.module('components.auth').directive 'authLogin', ( mBaseDirective ) ->

	class authLogin extends mBaseDirective

		restrict           : 'A'
		templateUrl        : 'components/auth/auth-login.html'
		# controller         : AuthLoginController
		# controller.$inject : [ '$scope' ]
		scope :
			username : '@'
			password : '@'

		constructor: ->
			super
			@controller = AuthLoginController 
			@controller.$inject = [ '$scope', '$state', 'Session', 'UserAuthToken' ]

	return new authLogin()