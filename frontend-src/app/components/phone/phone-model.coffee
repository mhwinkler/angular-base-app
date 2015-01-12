# class Phone
# 	constructor: ( $resource ) ->
# 		$resource 'phones/:phoneId.json', {}, 
# 			query: 
# 				method  : 'GET'
# 				isArray : true
# 				params  :
# 					phoneId : 'phones'
				

angular.module('components.phone').factory 'Phone', ( $resource ) ->
	$resource 'phones/:phoneId.json', {}, 
		query: 
			method  : 'GET'
			isArray : true
			params  :
				phoneId : 'phones'