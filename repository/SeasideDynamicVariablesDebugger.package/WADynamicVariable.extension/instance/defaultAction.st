*SeasideDynamicVariablesDebugger
defaultAction
	" This is an override from SeasidePharoDebugging because before raising a signal we 
	first check if we have the value stored. That way, everywhere 
	we evaluate code in a debugger that end ups doing 'WACurrentRequestContext value' will simply  
	get up to this place. Since in WAPharoDebuggererErrorHandler >> #open:  we
	stored the dynamic variables, we should have the value "
	
	
	"The only thing that below code (the check of #getAllOpenedSeasideDebuggers) solves is that we would not be getting the value of dynamic variables from previous errors (class side variable of WADynamicVariablesErrorHandler) if there is none debugger opened from a seaside continuation. If you let a debugger opened debugging a seaside error, then there is no magic we can do I think. 
Imagine you were in a debugger and you evaluated: 'WAComponent new session'. The signal raised from there knows NOTHING about the debugger where that was evaluated... so at #defaultAction level you know nothing about what triggered that."
	^ self getAllOpenedSeasideDebuggers 
		ifEmpty: [ 
			Transcript show: 'No opened debugger with Seaside Debugger'.
			self class defaultValue ]
		ifNotEmpty: [  
			Transcript show: 'Found opened debugger with Seaside Debugger'.
			(WADynamicVariablesErrorHandler storedDynamicVariable: self class)
				ifNil: [ self class defaultValue ]
	]
	
	