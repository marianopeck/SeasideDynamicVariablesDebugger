exception handling
exceptionSelector
	"We add Halt so that this gets called to handleException: otherwise it is not"
	^ super exceptionSelector, Halt
	