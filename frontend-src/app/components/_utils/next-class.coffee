angular.module('components.utils').factory 'NextClass', ( BaseClass ) ->

	class NextClass extends BaseClass

		prop3: 'pnext3'
		prop4: 'pnext4'
		obj2:
			prop2: 'pnext2'

		constructor: ->
			super

			@prop3  = 'next3'
			@prop11 = 'next11'

			@obj3.prop1 = "ho"

		method2: ->
			console.log 'method2'

		
	return NextClass	