angular.module('components.utils.mBaseResource').provider 'mBaseResource', -> 
	
	class mBaseResourceProvider
		
		defaults :
			urlScheme  : null # null for local requests, http:// or https://
			urlHost    : null # domain name part
			urlPort    : null # optional port number
			urlPrefix  : null # optional path prefix
			
		getConfig : =>
			config = @defaults
			_.forIn config, ( value, key ) =>
				config[key] = @[key] if @[key]?

		getBaseUrl : =>
			config = @getConfig()
			return "#{ config.urlScheme || '' }#{ config.urlHost || '' }#{ if config.urlPort? then ':' + config.urlPort else '' }#{ config.urlPrefix || '' }"

		getIsExternal : =>
			config = @getConfig()
			return config.urlHost?

		constructor: ->
			
			@$get = ( $resource, $q, mBaseCollection ) =>
				
				class mBaseResource

					resource       : null
					actions        : null
					baseUrl        : null
					defaultActions :
						get : 
							method : 'GET'
							sendData : false
						query :
							method   : 'GET'
							isArray  : false # prevents $resource from trying to automatically parse the result
							hasArray : true 
							sendData : false
						create :
							method : 'POST'
							sendData : true
						update :
							method : 'PUT'
							sendData : true
						delete :
							method : 'DELETE'
							sendData : false

					
					constructor: ( @baseModel, config = {} ) ->

						_.forIn config, ( value, key ) =>
							@[key] = value

						unless @baseCollection?
							@baseCollection = mBaseCollection

						@baseUrl    = mBaseResourceProvider::getBaseUrl()
						@isExternal = mBaseResourceProvider::getIsExternal()
						@primaryKey = @baseModel::getPrimaryKey()
						@actions    = angular.extend {}, @defaultActions, @actions
						@fullUrl    = "#{ @baseUrl || '' }#{ @baseModel::getUrl() }"
						
						@resource = $resource "#{ @fullUrl }/:#{ @primaryKey }", {}, @actions

						angular.forEach @actions, ( actionDefinition, actionName ) =>
							# if @isExternal
							# 	actionDefinition.method   = 'JSONP'

							@[actionName] = ( parameters, postData, successCallback, failureCallback ) =>
								@action( actionName, actionDefinition, parameters, postData, successCallback, failureCallback )
						# @query  = @resource.query
						# @update = @resource.update
						# @delete = @resource.delete

					action: ( actionName, actionDefinition, parameters, postData, successCallback, failureCallback ) =>
						unless actionDefinition.sendData
							# back off params by 1 becuase postData doesn't exist
							failureCallback = successCallback
							successCallback = postData
						
						deferred = $q.defer()
						if actionDefinition.hasArray
							responseResource = @collection()
						else
							responseResource = @model()
						
						success = ( responseData, headersGetter ) => 
							@success responseResource, actionName, actionDefinition, responseData, headersGetter, deferred, successCallback, failureCallback
						error = ( rejectedResponse ) => 
							@error responseResource, actionName, actionDefinition, rejectedResponse, deferred, failureCallback

						if actionDefinition.sendData
							@resource[actionName] parameters, postData, success, error
						else
							if @isExternal
								@resource[actionName] parameters + { callback: 'JSON_CALLBACK' }, success, error
							else
								@resource[actionName] parameters, success, error

						return responseResource

					success: ( responseResource, actionName, actionDefinition, responseData, headersGetter, deferred, successCallback, errorCallback ) =>

						if !actionDefinition.hasArray
							responseResource.setAttributes responseData.data
						else
							for data in responseData.data
								model = @model().setAttributes data
								responseResource.addTo model
								
						
						# angular.extend responseResource, value
						
						$q.when( if angular.isFunction @[ "#{ actionName }Success" ] then @[ "#{ actionName }Success" ] responseResource, headersGetter else null ).then(
							=> $q.when( if angular.isFunction successCallback then successCallback responseResource, headersGetter else null ).then(
								=> deferred.resolve responseResource # only resolves the request if all the intermediary success callbacks' return values also resolve
							)
							( rejection ) => @error responseResource, rejection, theirError, deferred, actionName, actionDefinition, parameters, postData # and will be handled the same as a rejected request otherwise
						)

						return responseResource

					error: ( responseResource, actionName, actionDefinition, rejectedResponse, deferred, failureCallback ) =>
						if failureCallback?
							failureCallback rejectedResponse

					model: =>
						return new @baseModel @

					collection: =>
						return new @baseCollection @

					test: ->
						console.log 'Test 1'

				mBaseResource.baseUrl = @getBaseUrl()
				return mBaseResource

				# return {
				# 	model: ( urlPath, config = {} ) =>
				# 		fullConfig = @getConfig()
				# 		_.forIn config, ( value, key ) ->
				# 			fullConfig[key] = value
				# 		return new mBaseModel urlPath, fullConfig
				# }
			@$get.$inject = [ '$resource', '$q', 'mBaseCollection' ]
		
	return new mBaseResourceProvider()
	

angular.module( 'components.utils.mBaseResource' ).factory 'mBaseModel', () ->

	class mBaseModel 

		_primaryKey : 'id'
		_name       : null
		_url        : null
		_requester  : null
		_isNewModel : true
		_attributes : {}

		constructor: ( requester ) ->
			@_validationErrors = {}
			# establish default properties
			angular.forEach @_attributes, ( value, key ) =>
				@[key] = value unless @[key]?
			@_requester = requester

		setAttributes: ( data ) =>
			# set only properties that we expect
			angular.forEach @_attributes, ( value, key ) =>
				@[key] = data[key] if data[key]?
			return @

		getAttributes: =>
			attrs = {}
			angular.forEach @_attributes, ( value, key ) =>
				attrs[key] = @[key]
			return attrs

		addFieldErrors: ( data ) =>
			angular.forEach data, ( errors, field ) =>
				@_validationErrors[field] = errors

		getFieldErrors: ( data ) =>
			return if @_validationErrors? then @_validationErrors else {}
		getUrl: =>
			return @_url

		getPrimaryKeyName: =>
			return @_primaryKey

		getPrimaryKey: =>
			return @[@_primaryKey]

		save: ( successCallback, failureCallback ) =>
			if @_isNewModel
				@_requester.create {}, @getAttributes()
				, ( responseResource, headersGetter ) => 
					@setAttributes responseResource.getAttributes()
					@_isNewModel = false 

					return successCallback responseResource, headersGetter
				, ( rejectedResponse ) =>
					if rejectedResponse?.data?.responseCode is 'FieldErrors'
						@.addFieldErrors rejectedResponse.data.fieldErrors

					return failureCallback rejectedResponse
			else
				tempParams = {}
				tempParams[@getPrimaryKeyName()] = @getPrimaryKey()
				@_requester.update tempParams, @getAttributes(), @, successCallback, failureCallback

		delete: ( successCallback, failureCallback ) =>
			tempParams = {}
			tempParams[@getPrimaryKeyName()] = @getPrimaryKey()
			@_requester.delete tempParams, successCallback, failureCallback


angular.module( 'components.utils.mBaseResource' ).factory 'mBaseCollection', () ->

	class mBaseCollection 

		offset : null
		limit  : null
		params : null
		
		constructor: ( @_requester ) ->
			# establish default properties
			angular.forEach @_attributes, ( value, key ) =>
				@[key] = value unless @[key]?
			
			@returnArray = []
			angular.extend @returnArray, @

			return @returnArray

		addTo: ( model ) =>
			# model = new @_baseModel().setAttributes data
			@returnArray.push model

		getUrl: =>
			return @_url

		getPrimaryKey: =>
			return @[@_primaryKey]

		getPrimaryKeyName: =>
			return @_primaryKey

		save: ( successCallback, failureCallback ) =>
			if @_isNewModel
				@_requester.save @, => 
					@_isNewModel = false 
					return successCallback 
				, failureCallback
			else
				@_requester.update @, successCallback, failureCallback

		delete: ( successCallback, failureCallback ) =>
			@_requester.delete @, successCallback, failureCallback


	