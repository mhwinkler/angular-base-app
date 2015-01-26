angular.module('components.utils').factory 'mBaseDirective', ->
	
	class mBaseDirective 
		
		templateUrlPrefix: '/* @echo applicationConfig_defaultScheme */' + 
			'/* @echo applicationConfig_staticFileDomain */' + '/' +
			'/* @echo applicationConfig_staticFileDirectory */' + '/' + 
			'/* @echo templatesDir */' + '/'
		
		constructor: ->
			if @templateUrl? and @templateUrlPrefix
				@templateUrl = @templateUrlPrefix + @templateUrl
			if @scope?
				@scope = @scope

	return mBaseDirective