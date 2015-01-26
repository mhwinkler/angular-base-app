
angular.module('components.utils.base-router').config ( $stateProvider ) ->

	$stateProvider.decorator 'views', (state, parent) ->
		result = {}
		views  = parent(state)
		angular.forEach views, ( config, name ) ->
			autoName = (state.name + "." + name).replace(".", "/")
			if config.templateUrl
				config.templateUrl = '/* @echo applicationConfig_defaultScheme */' + 
					'/* @echo applicationConfig_staticFileDomain */' + '/' +
					'/* @echo applicationConfig_staticFileDirectory */' + '/' + 
					'/* @echo templatesDir */' + '/' +
					config.templateUrl
			result[name] = config
		return result

