callbacks tests
callbackAndHalt
	| component | 
	component := WAComponent new. 
	Transcript show: 'Session identity hash in #callbackAndHalt is ', self session identityHash asString, ' from component ', self identityHash asString; cr. 
	self halt.  
	"Uncomment below code, evaluate it, and the identity hash should match the one displayed in the transcript. You can also evaluate this code from the inspector of the debugger."
	"component requestContext session identityHash"
	"You can also make sure you are matching the correct component instance..
	just in case there are many entries in the transcript"
	"self identityHash" 