class phoneItem extends m.Directive

	restrict    : 'E'
	templateUrl : 'components/phone/phone-item.html'
	scope       :
		name        : '@'
		description : '@'
		href        : '@'
		imgSrc      : '@'	

angular.module('components.phone').directive 'phoneItem', -> newPhoneItem = new phoneItem()