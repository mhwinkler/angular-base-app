angular.module('components.utils').filter 'checkmark', ->
	return (input) ->
		return if input then '\u2713' else '\u2718'
