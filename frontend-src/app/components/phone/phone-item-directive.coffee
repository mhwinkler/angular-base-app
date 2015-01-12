angular.module('components.phone').directive 'phoneItem', ->
	return {
		restrict : 'E'
		scope    : 
			name        : '@'
			description : '@'
			href        : '@'
			imgSrc      : '@'
		templateUrl: window.abaTemplatePath + '/components/phone/phone-item.html'
	}