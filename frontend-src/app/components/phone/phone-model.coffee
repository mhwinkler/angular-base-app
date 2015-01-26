###
angular.module('components.phone').factory 'BaseModel', ( restmod ) ->
	return restmod.mixin
		$config: 
			urlPrefix: 'http://local.lead-secure.com/api/1'

angular.module('components.phone').factory 'Phone', ( restmod, BaseModel ) ->
	return restmod.model( '/phone' ).$mix BaseModel

angular.module('components.phone').factory 'Car', ( restmod, BaseModel ) ->
	return restmod.model( '/car' ).$mix BaseModel
###

angular.module('components.phone').factory 'Phone', ( mBaseResource, mBaseModel ) ->

	class Phone extends mBaseModel

		_name       : 'Phone'
		_url        : '/phone'
		_attributes : 
			id       : null
			age      : null
			imageUrl : null
			name     : null
			snippet  : null

	class PhoneRequester extends mBaseResource
		
		test: ->
			super
			console.log 'Test 2'
			# @model = mBaseResource.model '/phone'

	return new PhoneRequester Phone

angular.module('components.phone').factory 'Car', ( mBaseResource, mBaseModel ) ->

	class Car extends mBaseModel

		_name       : 'Car'
		_url        : '/car'
		_attributes : 
			id       : null
			age      : null
			imageUrl : null
			name     : null
			snippet  : null

	class CarRequester extends mBaseResource
		
		test: ->
			super
			console.log 'Test 2'
			
	return new CarRequester Car
