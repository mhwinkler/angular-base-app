angular.module('/* @echo name */').config ($urlRouterProvider) ->
	$urlRouterProvider.otherwise '/phones'

# TODO: Automagically append the template path to relative templateUrls
# angular.module('states').config ( $stateProvider ) ->
# 	$stateProvider.decorator 'views', (state, parent) ->
# 		result = {}
# 		views  = parent(state)
# 		angular.forEach views, ( config, name ) ->
# 			autoName           = (state.name + "." + name).replace(".", "/")
# 			if config.templateUrl
# 				config.templateUrl = 
# 					'/* @echo applicationConfig_staticFileDirectory */' + '/' +
# 					'/* @echo templatesDir */' + '/' +
# 					config.templateUrl
# 			result[name]       = config
# 		return result
