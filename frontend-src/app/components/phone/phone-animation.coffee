
class PhoneAnimation
	animateUp: ( element, className, done ) ->
		if className isnt 'active'
			return
		
		element.css
			position : 'absolute'
			top      : 500
			left     : 0
			display  : 'block'
		

		jQuery(element).animate { top: 0 }, done

		return (cancel) ->
			if cancel
				element.stop()
	
	animateDown: ( element, className, done ) ->
		if className isnt 'active'
			return
		
		element.css
			position : 'absolute'
			left     : 0
			top      : 0
		
		jQuery(element).animate { top: -500 }, done

		return (cancel) ->
			if cancel
				element.stop()

	constructor: ->
		return {
			addClass   : @animateUp
			removeClass: @animateDown
		}

angular.module('components.phone').animation '.phone', -> new PhoneAnimation
