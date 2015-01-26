window.m = {}

angular.module 'components', [
	'ngResource'
	'components.utils'
	'components.auth'
	'components.phone'
]


m.BaseDirective = class mBaseDirective 
	
	templateUrlPrefix: '/* @echo applicationConfig_defaultScheme */' + 
		'/* @echo applicationConfig_staticFileDomain */' + '/' +
		'/* @echo applicationConfig_staticFileDirectory */' + '/' + 
		'/* @echo templatesDir */' + '/'
	
	constructor: ->
		if @templateUrl? and @templateUrlPrefix
			@templateUrl = @templateUrlPrefix + @templateUrl
		if @scope?
			@scope = @scope

m.Directive = class mDirective extends mBaseDirective
	
	