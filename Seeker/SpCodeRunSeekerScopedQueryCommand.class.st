Class {
	#name : #SpCodeRunSeekerScopedQueryCommand,
	#superclass : #SpCodeSelectionCommand,
	#category : #'Seeker-Commands'
}

{ #category : #defaults }
SpCodeRunSeekerScopedQueryCommand class >> defaultIconName [

	^ #exception
]

{ #category : #default }
SpCodeRunSeekerScopedQueryCommand class >> defaultName [ 

	^ 'Run Seeker Scoped Query...'
]

{ #category : #default }
SpCodeRunSeekerScopedQueryCommand class >> defaultShortcutKey [

	^ nil
]

{ #category : #private }
SpCodeRunSeekerScopedQueryCommand >> compile: aStream for: anObject in: evalContext [
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
SpCodeRunSeekerScopedQueryCommand >> debug: aStream [
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
SpCodeRunSeekerScopedQueryCommand >> debug: aCompiledMethod receiver: anObject in: evalContext [

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
SpCodeRunSeekerScopedQueryCommand >> execute [

	| selection |
	selection := self selectedTextOrLine.
	selection ifEmpty: [ ^ '' ].

	self debug: selection readStream.
	self inform: 'SeekerDebugger: Time-Traveling enabled'
]
