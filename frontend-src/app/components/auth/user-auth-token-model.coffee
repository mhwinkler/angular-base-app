angular.module('components.auth').factory 'UserAuthToken', ( mBaseResource, mBaseModel ) ->

	class UserAuthToken extends mBaseModel

		_name       : 'UserAuthToken'
		_url        : '/user-auth-token'
		_attributes : 
			id           : null
			first_name   : null
			last_name    : null
			email        : null
			password     : null
			access_token : null

		# constructor: ->
		# 	super
		# 	@_validationErrors

	# class UserAuthTokenRequester extends mBaseResource

	return new mBaseResource UserAuthToken

