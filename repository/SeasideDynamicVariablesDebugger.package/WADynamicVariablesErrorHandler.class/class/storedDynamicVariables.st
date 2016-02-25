accessing
storedDynamicVariables
	^ StoredDynamicVariables ifNil: [ StoredDynamicVariables := Dictionary new ]