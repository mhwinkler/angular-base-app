angular.module('components.utils.session').service 'Session', ->
	
	class Session 

		constructor: ->
			@sessionVars = {}
			@isGuest = true
			
		set: ( key, value ) =>
			@sessionVars[key] = value
			return @

		get: ( key ) =>
			return if @sessionVars[key]? then @sessionVars[key] else null

		logout: =>
			@isGuest = true
			@sessionVars = {}


	return new Session()