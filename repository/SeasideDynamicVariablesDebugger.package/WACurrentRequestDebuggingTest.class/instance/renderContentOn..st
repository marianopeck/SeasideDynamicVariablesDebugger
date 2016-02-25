rendering
renderContentOn: html
	html form with: [ 
		html submitButton 
			text: 'Test rendering phase with DNU';
			callback: [ testSelector := #renderingAndDNU: ].
		html submitButton 
			text: 'Test rendering phase with Halt';
			callback: [ testSelector := #renderingAndHalt: ].	
	
		html break.
		
		html submitButton 
			text: 'Test callback phase with DNU';
			callback: [ self callbackAndDNU ].
		html submitButton 
			text: 'Test callback phase with Halt';
			callback: [ self callbackAndHalt ].
		
	].
		
	testSelector ifNotNil: [ 
		self perform: testSelector with: html
	]