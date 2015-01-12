window.abaTemplatePath = '/* @echo applicationConfig_defaultScheme */' + 
	'/* @echo applicationConfig_staticFileDomain */' + '/' +
	'/* @echo applicationConfig_staticFileDirectory */' + '/' + 
	'/* @echo templatesDir */'

angular.module '/* @echo name */', [
  'components.utils'
  'components.phone'
  'states.phones'
  'states.phones.list'
  'states.phones.detail'
]