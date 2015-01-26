unless window.m? 
	window.m = {}

window.abaTemplatePath = '/* @echo applicationConfig_defaultScheme */' + 
	'/* @echo applicationConfig_staticFileDomain */' + '/' +
	'/* @echo applicationConfig_staticFileDirectory */' + '/' + 
	'/* @echo templatesDir */' + '/'

angular.module '/* @echo name */', [
	'ngMessages'
	'components' 
	'states'
]