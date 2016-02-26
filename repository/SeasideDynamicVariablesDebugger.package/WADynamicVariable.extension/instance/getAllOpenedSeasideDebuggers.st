*SeasideDynamicVariablesDebugger
getAllOpenedSeasideDebuggers
	"Very very hackish method. Likely to be broken as GT debugger or Pharo debugger changes, or even Seaside #openDebuggerOn: changs."
	| allDebuggers |
	allDebuggers := OrderedCollection new. 
	"We search all debuggers...either SpecDebugger or GTGenericStackDebugger"
	allDebuggers addAll: ((UIManager default currentWorld submorphs select: [:w | (w model isKindOf: WindowModel) and: [ w model model isKindOf: SpecDebugger ]  ])  collect: [ :each | each model model ]).
	allDebuggers addAll: ((UIManager default currentWorld submorphs select: [ :each | each model isKindOf: GTGenericStackDebugger ]) 
		collect: [ :each | each model ]).
	"We now only select those that are from a seaside error debugging"
	^ allDebuggers select: [ :each2 | (each2 session interruptedProcess suspendedContext method selector = #openDebuggerOn:)
										and: [each2 session interruptedProcess suspendedContext sender receiver class = WADynamicVariablesErrorHandler] ].		
	