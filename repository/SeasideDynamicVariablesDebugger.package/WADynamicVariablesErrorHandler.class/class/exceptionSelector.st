exception handling
exceptionSelector
	"We add Halt so that this gets called to handleException: otherwise it does not"
	^ super exceptionSelector, Halt
	