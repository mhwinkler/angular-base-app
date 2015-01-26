angular.module('components.utils').factory 'BaseClass', ->

	class BaseClass

		prop1: 'pbase1'
		prop2: 'pbase2'
		prop3: 'pbase3'
		prop4: 'pbase4'
		prop5: 'pbase5'
		prop6: 'pbase6'
		prop7: 'pbase7'
		prop8: 'pbase8'
		prop9: 'pbase9'
		obj1: 
			prop1: 'pobj1'
		obj2:
			prop1: 'pobj1'

		constructor: ->

			@prop1  = 'base1'
			@prop10 = 'base10'
			@obj3 = 
				prop1 : "howdy"
				prop2 : "howdy"
				prop3 : "howdy"
				prop4 : "howdy"

		method1: =>

			console.log 'pbasemethod1'

			console.log @prop1 
			console.log @prop2 
			console.log @prop3
			console.log @prop4
			console.log @prop5
			console.log @prop6
			console.log @prop7
			console.log @prop8
			console.log @prop9
			console.log @prop10
			console.log @prop11
			console.log @prop12
			console.log @prop13

		
	return BaseClass	