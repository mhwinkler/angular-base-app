describe 'service', ->

	beforeEach module('components.phone')

	it 'check the existence of Phone factory', inject( (Phone) ->
		expect(Phone).toBeDefined()
	)
