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

{ #category : #execution }
SpCodeRunSeekerScopedQueryCommand >> execute [

	self showQueriesMenu 
]

{ #category : #private }
SpCodeRunSeekerScopedQueryCommand >> makeProcess: aStream [
	| method doItReceiver doItContext |

	(self context respondsTo: #doItReceiver)
		ifTrue: [ 
			doItReceiver := self context doItReceiver.
			doItContext := self context doItContext ]
		ifFalse: [ 
			doItReceiver := doItContext := nil ].
		
	method := self compile: aStream for: doItReceiver in: doItContext.
	method isReturnSpecial
		ifTrue: [ self inform: 'Nothing to execute, the expression is optimized'.
			^ nil ].
	method notNil
		ifTrue: [ ^self makeProcessFor: method receiver: doItReceiver in: doItContext ].
		^nil
]

{ #category : #private }
SpCodeRunSeekerScopedQueryCommand >> makeProcessFor: aCompiledMethod receiver: anObject in: evalContext [

	| process |
	process := [ 
	           aCompiledMethod
		           valueWithReceiver: anObject
		           arguments: (aCompiledMethod numArgs = 0
				            ifTrue: [ #(  ) ]
				            ifFalse: [ { evalContext } ]) ] newProcess.
	^process 
]

{ #category : #execution }
SpCodeRunSeekerScopedQueryCommand >> makeProgramStatesFromSelection [

	| selection proc|
	selection := self selectedTextOrLine.
	selection ifEmpty: [ ^ '' ].

	proc:=self makeProcess: selection readStream.
^ (SeekerDebugger headlessDebugForDoIt: proc) tracer newProgramStates 
]

{ #category : #'as yet unclassified' }
SpCodeRunSeekerScopedQueryCommand >> showQueriesMenu [

	| menu |
	menu := MenuMorph new.

	UserTTQ allSubclassesDo: [ :sc |
		| q |
		q := sc new.
		menu
			add: q ttqTitle
			target: [
				(sc queryFrom: self makeProgramStatesFromSelection)
					asOrderedCollection inspect ]
			selector: #value ].
	menu invokeModal
]
