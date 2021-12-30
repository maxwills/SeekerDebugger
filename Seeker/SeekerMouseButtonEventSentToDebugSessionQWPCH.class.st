Class {
	#name : #SeekerMouseButtonEventSentToDebugSessionQWPCH,
	#superclass : #QwPostCompilationHandler,
	#category : #'Seeker-ActivePragmas'
}

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> debugSessionCondition: aMouseButtonEvent [

	"returns true if the debug session should be created or not, according the the MouseButtonEvent state or global state"

	^ aMouseButtonEvent type == #mouseUp and: [ 
		  SeekerGlobals instance debugCommandKeysPressed ]
]

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> handleCompiledMethod: aMethod [

	"This is called by the quickWrap system if the method pragmas contains the pragma of this class"

	| proxy |
	proxy := QuickWrapSafeMethodProxy
		         onMethod: aMethod
		         delegateHandler: [ 
		         SeekerMouseButtonEventSentToDebugSessionQWPCH ]
		         selector:
		         #seekerDebugMouseButtonEventSentToWrapper:method:arguments:.
	proxy install
]

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> handledPragma [
"Don't add this to auto completion. It is only used once, and not by the debugger developer"
	"<qwpAddPragmaToAutocompletionIn:
	#SeekerActivePragmasAutocompletionHelper>"
	^ #skpDebugMouseButtonEventSentTo
]

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> seekerDebugMouseButtonEventSentToWrapper: receiver method: aMethod arguments: args [

	"Creates a Seeker debug session on particular event condition"

	"Used for the pragma"

	| val abort mouseButtonCondition |
	abort := [self inform: 'seekerDebugMouseButtonEventSentToWrapper aborted'. ^ receiver withArgs: args executeMethod: aMethod ].
	"We know the method. It is sentTo:. Just a sanity check"
	(MouseButtonEvent methodDict at: #sentTo: ifAbsent: abort) unproxifiedMethod == aMethod ifFalse: abort.
	"Might put this condition in a global"
	mouseButtonCondition := self 
		                        debugSessionCondition: receiver.
	mouseButtonCondition
		ifTrue: [ 
			SeekerSessionHelpers
				innerSeekerPragmaDebugSessionFor: [ 
				val := receiver withArgs: args executeMethod: aMethod ]
				withFlag: SeekerSessionHelpers makeOnceFlag ]
		ifFalse: [ val := receiver withArgs: args executeMethod: aMethod ].
	^ val
]
