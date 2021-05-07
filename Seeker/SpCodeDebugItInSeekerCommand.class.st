Class {
	#name : #SpCodeDebugItInSeekerCommand,
	#superclass : #SpCodeSelectionCommand,
	#category : #'Seeker-Commands'
}

{ #category : #defaults }
SpCodeDebugItInSeekerCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : #default }
SpCodeDebugItInSeekerCommand class >> defaultName [ 

	^ 'Debug it in Seeker'
]

{ #category : #default }
SpCodeDebugItInSeekerCommand class >> defaultShortcutKey [

	^ $d shift command mac 
		| $d shift control win
		| $d shift control unix
]

{ #category : #private }
SpCodeDebugItInSeekerCommand >> compile: aStream for: anObject in: evalContext [
	| methodClass |

	methodClass := evalContext
		ifNil: [ anObject class ]
		ifNotNil: [ evalContext methodClass ].

	^ context class compiler
		source: aStream;
		class: methodClass;
		context: evalContext;
		requestor: context; "it should enable a visibility of current tool variables in new debugger"
		noPattern: true;
		failBlock: [ ^ nil ];
		compile
]

{ #category : #private }
SpCodeDebugItInSeekerCommand >> debug: aStream [
	| method doItReceiver doItContext |

	(self context respondsTo: #doItReceiver)
		ifTrue: [ 
			doItReceiver := self context doItReceiver.
			doItContext := self context doItContext ]
		ifFalse: [ 
			doItReceiver := doItContext := nil ].
		
	method := self compile: aStream for: doItReceiver in: doItContext.
	method isReturnSpecial
		ifTrue: [ self inform: 'Nothing to debug, the expression is optimized'.
			^ self ].
	method notNil
		ifTrue: [ self debug: method receiver: doItReceiver in: doItContext ]
]

{ #category : #private }
SpCodeDebugItInSeekerCommand >> debug: aCompiledMethod receiver: anObject in: evalContext [

	| process suspendedContext |
	process := [ 
	           aCompiledMethod
		           valueWithReceiver: anObject
		           arguments: (aCompiledMethod numArgs = 0
				            ifTrue: [ #(  ) ]
				            ifFalse: [ { evalContext } ]) ] newProcess.
	SeekerGlobals instance watchProcess: process.
	suspendedContext := process suspendedContext.

	(OupsDebugRequest newForContext: suspendedContext)
		process: process;
		compiledMethod: aCompiledMethod;
		label: 'debug it';
		submit
]

{ #category : #execution }
SpCodeDebugItInSeekerCommand >> execute [
	| selection |
	
	selection := self selectedTextOrLine.
	selection ifEmpty: [ ^ '' ].
	
	self debug: selection readStream	
]
