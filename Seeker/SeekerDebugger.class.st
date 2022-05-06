"
# What is it
Seeker is a time travel debugger extension. It can work with different components that grant different implementation for time travel features.  It doesn't know the ""inside"" of the components, only their interfaces. Because of this, the initialization of components must be done outside (Think of dependency injection). 
The step granularity and graph (execution model) depends directly on the components.

## Pharo Comment

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	stepper:		<Object>


    Implementation Points
"
Class {
	#name : #SeekerDebugger,
	#superclass : #Object,
	#traits : 'TDebuggerUpdateCoordinatorClient',
	#classTraits : 'TDebuggerUpdateCoordinatorClient classTrait',
	#instVars : [
		'stDebugger',
		'tracer',
		'plugins',
		'seekerDebuggerPresenter',
		'instanceNumber'
	],
	#classVars : [
		'instanceNumberTotal'
	],
	#category : #'Seeker-Core'
}

{ #category : #'as yet unclassified' }
SeekerDebugger class >> headlessDebug: aProcess [

	"not recommended to use this method. Prefer using the block one or manually specifying the offset to ensure that the execution can actually be replayed"

	"Why the offset? In a freshly created process from a block, the first context of aProcess is usually the one with the code to initialize and terminate the process. The time-traveling back end should not replay any of that. That is why it is necessary to take a few steps to enter the actual code of the block. This method can be used only if the process is in a safe to replay context already"

	^ self headlessDebug: aProcess offsetBytecodes: 0
]

{ #category : #'as yet unclassified' }
SeekerDebugger class >> headlessDebug: aProcess offsetBytecodes: aNumber [

	| s |
	s := self newFor: (SeekerDummyStDebugger new
			      interruptedProcess: aProcess;
			      yourself).
	s tracer headless: true.
	aNumber > 0 ifTrue: [ 1 to: aNumber do: [ :i | s tracer stepper basicStepBytecode ] ].
	s quickSetup.
	^ s
]

{ #category : #'as yet unclassified' }
SeekerDebugger class >> headlessDebugBlock: aBlock [

	| p s |
	p := Process
		     forContext: [ 
			     aBlock value.
			     "IMPORTANT: Do not step over next line of code. See method comments for details"
			     (Processor respondsTo: #terminateRealActive)
				     ifTrue: [ Processor terminateRealActive ]
				     ifFalse: [ Processor terminateActive ] ] asContext
		     priority: Processor activePriority.
	s := self headlessDebug: p offsetBytecodes: 2. "heuristic"
	^ s
]

{ #category : #'instance creation' }
SeekerDebugger class >> newFor: aStDebugger [

	"Initializes a seeker debugger with a default-level stepper and trace.
    Returns a SeekerDebugger"

	| debugger stepper updateCoordinator |
	updateCoordinator := DebuggerUpdateCoordinator new. "The coordinator is owned by the presenter"
	updateCoordinator stDebugger: aStDebugger.

	"Initialize the DebuggerStepperBase subclass to be injected in the seeker debugger"
	stepper := SkQueryExperimentalTracer new. "SeekerGlobals instance defaultStepperClass new"
	stepper stDebugger: aStDebugger.
	stepper debuggedProcess: aStDebugger interruptedProcess. "aStDebugger session interruptedProcess"
	stepper debuggerUpdateCoordinator: updateCoordinator.
	updateCoordinator tracer: stepper.

	debugger := SeekerDebugger new.
	debugger tracer: stepper.
	debugger stDebugger: aStDebugger.
	debugger debuggerUpdateCoordinator: updateCoordinator.
	stepper seeker: debugger.
	^ debugger
]

{ #category : #'as yet unclassified' }
SeekerDebugger class >> nextInstanceID [

	instanceNumberTotal ifNil: [ instanceNumberTotal := 0 ].
	^ instanceNumberTotal + 1
]

{ #category : #'accessing context' }
SeekerDebugger >> currentContext [
^tracer currentContext
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> doUnsafeCode: aBlock [

	"Catch exceptions and log them. Should be used in methods that are called when initializing the debugger to
prevent being unable to debug anything in case of failure
"

	aBlock onErrorDo: [ :e | 
		Transcript
			show: 'SeekerDebugger>>doUnsafeCode: ';
			cr;
			show: e asString;
			cr ]
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> evaluateExpression: aStream inContext: aContext [
   "Evaluates the expression coming from a stream. Uses the current context of the StDebugger"
   ^ aContext receiver class compiler
        source: aStream;
        context: aContext;
        receiver: aContext receiver;
        requestor: self;
        failBlock: [ nil ];
        evaluate
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> evaluateExpression: aString inContext: aContext throws: anError [
   "Evaluates the expression coming from a stream. Returns true or false if the given error was thrown on evaluation"
   [  aContext receiver class compiler
        source: aString;
        context: aContext;
        receiver: aContext receiver;
        requestor: self;
        failBlock: [ nil ];
        evaluate] on: anError do: [ :e| ^true ] . ^false
]

{ #category : #initialization }
SeekerDebugger >> initialize [

	self doUnsafeCode: [ 
		instanceNumberTotal ifNil: [ instanceNumberTotal := 0 ].
		instanceNumberTotal := instanceNumberTotal + 1.
		instanceNumber := instanceNumberTotal.
		plugins := OrderedCollection new.
		SeekerCache reset.
		super initialize.
		self initializePlugins ]
]

{ #category : #initialization }
SeekerDebugger >> initializePlugins [

	"(Pragma allNamed: #seekerDebuggerPlugin:) do: [ :pluginPragma | 
		| pluginClass plugin |
		pluginClass := pluginPragma method methodClass.
		plugin := pluginClass new.
		plugin initializeModel: self.
		plugins add: plugin ]"
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> instanceID [ 
	^ instanceNumber
]

{ #category : #accessing }
SeekerDebugger >> interruptedProcess [

	^ stDebugger interruptedProcess
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyCommandExecution: aCommand subEvent: aSymbol [

	self notifyPlugins
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyDebuggerInitialized [

	self notifyPlugins
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyExecutionMapped [

	self notifyExecutionMapped: tracer currentContext method
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyExecutionMapped: compiledMethod [

	self notifyPlugins
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyPlugins [

	| senderContext methodSelector |
	senderContext := thisContext sender.
	methodSelector := senderContext methodSelector.
	plugins do: [ :plugin | 
		(plugin handlesMethod: methodSelector) ifTrue: [ 
			plugin
				handleMethod: methodSelector
				withArguments: senderContext arguments ] ]
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyQueryFilterTextEntered: searchedString [

	self notifyPlugins
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifySessionEnd [ 
	
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> notifyTimeTravel: stateString [

	self notifyPlugins
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> quickSetup [

	| process |
	tracer ifNil: [ ^ self ].
	stDebugger ifNil: [ ^ self ].
	process := stDebugger interruptedProcess.
	process ifNil: [ ^ self ].
	tracer session: stDebugger session.
	tracer doMappingIfCorresponds.
	tracer componentsLateInitialization
]

{ #category : #starting }
SeekerDebugger >> restart [

	"Restarts the execution from the UserStart trace time (not bytecode one)"

	tracer timeTravelToUserStart
]

{ #category : #accessing }
SeekerDebugger >> seekerDebuggerPresenter [

	^ seekerDebuggerPresenter
]

{ #category : #accessing }
SeekerDebugger >> seekerDebuggerPresenter: anObject [

	seekerDebuggerPresenter := anObject
]

{ #category : #initialization }
SeekerDebugger >> setSelectedContextAsStartingPoint: aContext [
	tracer setSelectedContextAsStartingPoint: aContext
]

{ #category : #accessing }
SeekerDebugger >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
SeekerDebugger >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepBackInto [

	tracer stepBackInto
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepBackOver [
	tracer stepBackOver.
	Transcript clear.
	self printTrace
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepInto [

	tracer stepInto.
	"Transcript clear."
	self printTrace
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepOver [
	tracer stepOver.
	"Transcript clear.
	self printTrace"
]

{ #category : #accessing }
SeekerDebugger >> tracer [

	^ tracer
]

{ #category : #initialization }
SeekerDebugger >> tracer: aDebuggerStepper [
	tracer := aDebuggerStepper
]
