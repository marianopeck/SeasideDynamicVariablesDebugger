dynamic variables
clearAndStoreAllDynamicVariables
	"Clears all stored dynamic variables (from all subclasses) and store the new values of all of them"
	self reset.
	WADynamicVariable allSubclasses do: [:each | 
		self storeDynamicVariable: each 
	]