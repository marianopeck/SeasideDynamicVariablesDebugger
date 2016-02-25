dynamic variables
storedDynamicVariable: aDynamicVariableClass
	^ self storedDynamicVariables at: aDynamicVariableClass ifAbsent: [ ^ nil ]