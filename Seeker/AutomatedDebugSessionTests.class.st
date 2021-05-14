Class {
	#name : #AutomatedDebugSessionTests,
	#superclass : #TestCase,
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #compiling }
AutomatedDebugSessionTests >> compile: aStream for: anObject in: evalContext [
	| methodClass |

	methodClass := UndefinedObject .

	^ self class compiler
		source: aStream;
		class: methodClass;
		context: [] asContext;
		requestor: self; "it should enable a visibility of current tool variables in new debugger"
		noPattern: true;
		failBlock: [ ^ nil ];
		compile
]

{ #category : #'do-its' }
AutomatedDebugSessionTests >> createCleanContextFromSource: aString [

	| methodClass compiledMethod process |
	"debug: aCompiledMethod receiver: anObject in: evalContext
	| process suspendedContext session|"
	methodClass := UndefinedObject.

	compiledMethod := self class compiler
		                  source: aString;
		                  class: methodClass;
		                  context: [  ] asContext;
		                  requestor: UndefinedObject;
		                  "it should enable a visibility of current tool variables in new debugger"
		                  noPattern: true;
		                  failBlock: [ ^ nil ];
		                  compile.

	process := [ compiledMethod value ] newProcess
]

{ #category : #'do-its' }
AutomatedDebugSessionTests >> createCleanProcessForSource: aString [
|compiledMethod process suspendedContext|
"debug: aCompiledMethod receiver: anObject in: evalContext
	| process suspendedContext session|"

	process := [ 
		compiledMethod
			valueWithReceiver: UndefinedObject
			arguments: #() ]
			newProcess.
	suspendedContext := process suspendedContext.
	
]

{ #category : #'do-its' }
AutomatedDebugSessionTests >> createDebugProcessFromSource: aString [

	| methodClass compiledMethod process |
	"debug: aCompiledMethod receiver: anObject in: evalContext
	| process suspendedContext session|"
	methodClass := UndefinedObject.

	compiledMethod := self class compiler
		                  source: aString;
		                  class: methodClass;
		                  context: [  ] asContext;
		                  requestor: UndefinedObject;
		                  "it should enable a visibility of current tool variables in new debugger"
		                  noPattern: true;
		                  failBlock: [ ^ nil ];
		                  compile.

	process := [ compiledMethod value ] newProcess.
	process priority: Processor userInterruptPriority.
	^process
]

{ #category : #'do-its' }
AutomatedDebugSessionTests >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| process suspendedContext session|

	process := [ 
		aCompiledMethod
			valueWithReceiver: anObject
			arguments: #() ]
			newProcess.
	suspendedContext := process suspendedContext.
	
	(OupsDebugRequest newForContext: suspendedContext)
		process: process;
		compiledMethod: aCompiledMethod;
		label: 'debug it';
		submit
]

{ #category : #tests }
AutomatedDebugSessionTests >> testABlockDebugSession [

	"This code should openup a debugger on the given block"

	| blockToBeDebugged context session process debugger sessionForTests|
	blockToBeDebugged := [ 
	                     | myCol |
	                     myCol := OrderedCollection new.
	                     myCol add: 1.
	                     ^ myCol size ].
	context := blockToBeDebugged asContext.
	process := Process
		           forContext: context
		           priority: Processor userInterruptPriority.
	session := DebugSession
		           named: 'TimeTraveling test session'
		           on: process
		           startedAt: context.
		session exception: (OupsNullException fromSignallerContext: context).
		StDebugger debugSession: session.
		
	"That works, but not as cleanly as the Debug this context menu"
]

{ #category : #tests }
AutomatedDebugSessionTests >> testABlockDebugSession2 [

	"This code should openup a debugger on the given block"

	| blockToBeDebugged method context session process debugger sessionForTests doItReceiver doItContext |
	blockToBeDebugged := [ 
	                     | myCol |
	                     myCol := OrderedCollection new.
	                     myCol add: 1.
	                     ^ myCol size ] asString.
	"context := blockToBeDebugged asContext.
	process := Process
		           forContext: context
		           priority: Processor userInterruptPriority.
	session := DebugSession
		           named: 'TimeTraveling test session'
		           on: process
		           startedAt: context.
		session exception: (OupsNullException fromSignallerContext: context).
		StDebugger debugSession: session.
		"
"	| method doItReceiver doItContext |

	"
			doItReceiver := doItContext := nil.
		
	method := self compile: blockToBeDebugged for: nil in: nil.
self debug: method receiver: nil in: nil 
]

{ #category : #tests }
AutomatedDebugSessionTests >> testABlockDebugSession3 [

	"This code should openup a debugger on the given block"

	| blockToBeDebugged context session process debugger sessionForTests|
	blockToBeDebugged := [ 
	                     | myCol |
	                     myCol := OrderedCollection new.
	                     myCol add: 1.
	                     ^ myCol size ].

	process := self createDebugProcessFromSource: blockToBeDebugged asString.
	session := DebugSession
		           named: 'TimeTraveling test session'
		           on: process
		           startedAt: process suspendedContext.
		session exception: (OupsNullException fromSignallerContext: process suspendedContext).
		StDebugger debugSession: session.
		
	"That works, but not as cleanly as the Debug this context menu"
]