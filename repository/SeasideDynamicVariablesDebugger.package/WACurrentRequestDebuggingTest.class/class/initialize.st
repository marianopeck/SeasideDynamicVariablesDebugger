class initialization
initialize
	| app | 
	app := WAAdmin register: self asApplicationAt: 'tests/seasidepharodebugging'.
	app filter configuration at: #exceptionHandler put: WADynamicVariablesErrorHandler.