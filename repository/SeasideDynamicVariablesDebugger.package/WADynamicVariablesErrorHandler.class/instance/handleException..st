actions
handleException: anException
	"IMPORTANT: this is the same as superclass. The only difference is that we store the current dynamic variables so that we can have access to them from the debugger form each exception class #defaultValue"
	Transcript show: 'Pharo Handling exception: ', anException printString; cr.
	self class clearAndStoreAllDynamicVariables.
	"We want to handle Halt as an error, so that it goes via openDebuggerOn: and so we can 
	have a better WADynamicVariable >> getAllOpenedSeasideDebuggers."
	(Halt handles: anException) ifTrue: [ ^ self handleError: anException ].
	"We do not want to handle Deprecation as that would prevent the #defaultAction and hence the setting #raiseWarning: will be ignored and the debugger will always be opened, even if #raiseWarning: was false... "
	(Deprecation handles: anException) ifTrue: [ anException pass ]. 
	^ super handleException: anException
	