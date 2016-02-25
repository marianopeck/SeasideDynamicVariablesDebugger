dynamic variables
clearAndStoreAllDynamicVariables
	self reset.
	WADynamicVariable allSubclasses do: [:each | 
		self storeDynamicVariable: each 
	]