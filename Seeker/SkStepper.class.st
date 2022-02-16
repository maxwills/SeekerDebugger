"
Defines the stepping implementation, and follows the ""Stepping Pipeline"" design.
The pipeline essentially means that the stepping is divided into stages:
- Pre-Step
- Step
- Post-Step.

The main participation of this components is in the methods #stepBytecode (and variations).

In every stage, different components (SkComponent) participate to perform the expected behavior of the debugger.
Components can be disabled individually or replaced by a similar implementation to achieve different debugger configurations.

For example, the ExecutionRestorer component can be disabled, and then Seeker will perform replays without recovering the initial state.
This also means that it is easier to find errors in Seeker implementation by individually disable components.
"
Class {
	#name : #SkStepper,
	#superclass : #SkComponent,
	#instVars : [
		'tracer',
		'mapper',
		'iteratingFlag',
		'currentState',
		'skippableMethods',
		'skipFlag',
		'emergencyStopFlag',
		'systemCallsHandler'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkStepper >> bindComponents [

	"For safety, only use calls direcly over componentsHolder. Dont call methods on the components (they might be null)"

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState.
	mapper := componentsHolder mapper.
	systemCallsHandler := componentsHolder systemCallsHandler.
]

{ #category : #testing }
SkStepper >> cantStep [

	^ self isExecutionFinished or: [ self isRiskyStep ]
]

{ #category : #accessing }
SkStepper >> currentState [

	^ currentState
]

{ #category : #accessing }
SkStepper >> currentState: anObject [

	currentState := anObject
]

{ #category : #accessing }
SkStepper >> emergencyStopFlag [

	^ emergencyStopFlag
]

{ #category : #accessing }
SkStepper >> emergencyStopFlag: anObject [

	emergencyStopFlag := anObject
]

{ #category : #private }
SkStepper >> getAllMethodsOfPackageNamed: aString [

	| pkg methods |
	methods := OrderedCollection new.
	pkg := RPackageOrganizer default packageNamed: aString.
	"pkg definedClasses do: [ :cls | 
		methods addAll: cls methodDictionary values ].
	methods addAll: pkg extensionMethods."
	methods addAll: pkg methods.
	^ methods
]

{ #category : #'actions api' }
SkStepper >> handleEmergencyStopFlag [

	emergencyStopFlag := false.
	self inform: 'Seeker Emergency Stop'.
	tracer updateUI.
	^ false
]

{ #category : #initialization }
SkStepper >> initialize [

	super initialize.
	iteratingFlag := false.
	skipFlag := false.
	emergencyStopFlag := false.
	self initializeSkippableMethods
]

{ #category : #initialization }
SkStepper >> initializeSkippableMethods [

	"The list might have methods in common with the ones excluded form the queries"

	self flag:
		'first the method that interfere with the traversal of the execution'.
	skippableMethods := Set new.
	SeekerMetaDebugHelper doBlock: [ ^ self ].
	skippableMethods := #identityHash senders asSet.
	skippableMethods add: HashedCollection >> #grow.
	skippableMethods add: WeakKeyDictionary >> #noCheckAdd:.
	skippableMethods add: HashedCollection >> #fullCheck.
	"There is an exclussion here that modified the pragmadebug starting point. Need to chech which one"

	WorldMorph methodDictionary valuesDo: [ :v | skippableMethods add: v ].
	"	WorldMorph class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ]."
	skippableMethods add: Cursor >> #show.
	skippableMethods add: Morph >> #world.
	skippableMethods add: Morph >> #delete.
	skippableMethods add: Morph >> #invalidRect:.
	skippableMethods add: Morph >> #fillStyle:.
	skippableMethods add: WorldMorph >> #displayWorldSafely.
	SpMorphStyle methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	SpMorphStyle class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].

	Announcer methodDictionary valuesDo: [ :v | skippableMethods add: v ].
	Announcer class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].

	MorphicRenderLoop methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	MorphicRenderLoop class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	ClyQueryViewMorph methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	ClyQueryViewMorph class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].

	RPackage methodDictionary valuesDo: [ :v | skippableMethods add: v ].
	RPackage class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	self flag: 'Not dangerous, but simply for speed'.
	skippableMethods add: String >> #numArgs.
	skippableMethods add: Form >> #unhibernate.
	Rectangle methodDictionary valuesDo: [ :v | skippableMethods add: v ].
	ClyFullBrowserMorph class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	SmalltalkImage methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	SmalltalkImage class methodDictionary valuesDo: [ :v | 
		skippableMethods add: v ].
	skippableMethods addAll: (self getAllMethodsOfPackageNamed: #Rubric).
	skippableMethods addAll:
		(self getAllMethodsOfPackageNamed: 'AST-Core').
	skippableMethods addAll:
		(self getAllMethodsOfPackageNamed: 'FreeType').
	skippableMethods addAll:
		(self getAllMethodsOfPackageNamed: 'FreeType-Graphics').
	skippableMethods addAll:
		(self getAllMethodsOfPackageNamed: 'FreeType-Morphic').
	skippableMethods addAll:
		(self getAllMethodsOfPackageNamed: 'UnifiedFFI')
]

{ #category : #testing }
SkStepper >> isExecutionFinished [

	"Returns whether the debugged execution is finished"

	^ mapper isEndReached or: [ 
		  currentState context sender isNil or: [ 
			  currentState isDead or: [ tracer debuggedProcess isTerminating ] ] ]
]

{ #category : #testing }
SkStepper >> isRiskyStep [

	| context receiver |
	context := currentState context.
	receiver := context receiver.
	^ currentState methodSelector = #primitiveFailed or: [ 
		  receiver isClass
			  ifTrue: [ 
			  receiver == TestResult and: [ context methodSelector = #failure ] ]
			  ifFalse: [ 
				  currentState methodSelector = #defaultAction and: [ 
					  receiver class inheritsFrom: Exception ] ] ]
]

{ #category : #accessing }
SkStepper >> iteratingFlag [

	^ iteratingFlag
]

{ #category : #accessing }
SkStepper >> iteratingFlag: anObject [

	^ iteratingFlag := anObject
]

{ #category : #accessing }
SkStepper >> mapper [

	^ mapper
]

{ #category : #accessing }
SkStepper >> mapper: anObject [

	mapper := anObject
]

{ #category : #initialization }
SkStepper >> setEmergencyStopFlag [

	iteratingFlag ifFalse: [ ^ self ].
	emergencyStopFlag := true.
	tracer preventNextTimeRestorationOfLiveState: true
]

{ #category : #accessing }
SkStepper >> skipFlag [

	^ skipFlag
]

{ #category : #accessing }
SkStepper >> skipFlag: anObject [

	skipFlag := anObject
]

{ #category : #accessing }
SkStepper >> skippableMethods [

	^ skippableMethods
]

{ #category : #accessing }
SkStepper >> skippableMethods: anObject [

	skippableMethods := anObject
]

{ #category : #'actions api' }
SkStepper >> stepBytecode [

	^ self
		  stepBytecodeUntilConditionIsTrue: (SeekerCounter countTo: 2)
		  doingAfterEachStep: nil
]

{ #category : #'actions api' }
SkStepper >> stepBytecodeDoingAfterStep: aBlock [

	self
		stepBytecodeUntilConditionIsTrue: (SeekerCounter countTo: 2)
		doingAfterEachStep: aBlock
]

{ #category : #'actions api' }
SkStepper >> stepBytecodeUntilConditionIsTrue: aBlock [

	^ self
		  stepBytecodeUntilConditionIsTrue: aBlock
		  doingAfterEachStep: nil
]

{ #category : #'actions api' }
SkStepper >> stepBytecodeUntilConditionIsTrue: aBlock doingAfterEachStep: afterStepBlock [

	"an optimized stepping mechanisms. Skips a lot of potentially unnecessary* code"

	"(*)In Pharo 10, current date 2021/12 there is only one class encoder. So, we interpret instructions for it.
This will fail if the code relies on more encoders (Need to test in Pharo 9.0)"

	| instrStream currentContext debuggedProcess |
	debuggedProcess := tracer debuggedProcess.
	currentContext := tracer currentContext.
	iteratingFlag := true.
	[ "currentCtx := self currentContext."
	instrStream := InstructionStream on: currentContext compiledCode pc: currentContext pc.
	Processor activeProcess
		evaluate: [ 
			[ (emergencyStopFlag or: aBlock) or: [ self cantStep ] ] whileFalse: [ 
				| previousContext startingNode |
				previousContext := currentContext.
				startingNode := currentState node.
				tracer doPreStepProcess.
				"currentContext stepIntoQuickMethod: true."
				currentContext := skipFlag
					                  ifTrue: [ 
						                  skipFlag := false.
						                  debuggedProcess completeStep: currentContext ]
					                  ifFalse: [ 
						                  (systemCallsHandler enabled and: [ systemCallsHandler isSystemCall ])
							                  ifTrue: [ 
								                  systemCallsHandler handleSystemCall: [ 
									                  instrStream interpretNextSistaV1InstructionFor: currentContext ] ]
							                  ifFalse: [ instrStream interpretNextSistaV1InstructionFor: currentContext ] ].
				tracer currentContext: currentContext.
				instrStream method: currentContext compiledCode pc: currentContext pc.
				debuggedProcess suspendedContext: currentContext.
				tracer doPostStepProcessWithPrevNode: startingNode andPrevContext: previousContext.
				afterStepBlock ifNotNil: afterStepBlock ] ]
		onBehalfOf: debuggedProcess.
	true ] ensure: [ iteratingFlag := false ].
	emergencyStopFlag ifTrue: [ self handleEmergencyStopFlag ]
]

{ #category : #accessing }
SkStepper >> tracer [

	^ tracer
]

{ #category : #accessing }
SkStepper >> tracer: anObject [

	tracer := anObject
]
