Class {
	#name : #SeekerMouseButtonEventSentToDebugSessionQWPCH,
	#superclass : #QwPostCompilationHandler,
	#category : #'Seeker-ActivePragmas'
}

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> debugSessionCondition: aMouseButtonEvent [

	"returns true if the debug session should be created or not, according the the MouseButtonEvent state or global state"

	SeekerConfig default enableMouseButtonEventDebug ifFalse: [ ^ false ].
	SeekerGlobals instance debugCommandKeysPressed ifFalse: [ ^ false ].
	^ aMouseButtonEvent type switch
		  case: #mouseUp do: [ SeekerConfig default handleMouseUpEvent ];
		  case: #mouseDown
		  do: [ SeekerConfig default handleMouseDownEvent ];
		  defaultCase: false
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
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> openDebugSessionForReceiver: receiver onMethod: aMethod eventReceiver: anEventReceiver withMorph: aMorph [

	| tmp newArgs res eventCopy |
	eventCopy := receiver shallowCopy. "maybe this copy is unnecessary"
	eventCopy source: receiver source shallowCopy.
	anEventReceiver isMorph
		ifTrue: [ 
			tmp := anEventReceiver.
			newArgs := { tmp } ]
		ifFalse: [ 
			tmp := anEventReceiver shallowCopy.
			tmp morph: aMorph.
			newArgs := { tmp } ].

	SeekerSessionHelpers
		innerSeekerPragmaDebugSessionFor: [ 
		res := eventCopy withArgs: newArgs executeMethod: aMethod ]
		withFlag: SeekerSessionHelpers makeOnceFlag.
	^ res
]

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> seekerDebugMouseButtonEventSentToWrapper: receiver method: aMethod arguments: args [

	"Creates a Seeker debug session on particular event condition"

	"Used for the pragma"

	| val abort mouseButtonCondition eventReceiver |
	abort := [ 
	         self inform:
		         'seekerDebugMouseButtonEventSentToWrapper aborted'.
	         ^ receiver withArgs: args executeMethod: aMethod ].
	"We know the method. It is sentTo:. Just a sanity check"
	(MouseButtonEvent methodDict at: #sentTo: ifAbsent: abort)
		unproxifiedMethod == aMethod ifFalse: abort.
	eventReceiver := args first. "copy"
	"Might put this condition in a global"
	mouseButtonCondition := self debugSessionCondition: receiver.
	mouseButtonCondition
		ifTrue: [ 
			| debuggedMorph |
			debuggedMorph := eventReceiver isMorph
				                 ifTrue: [ eventReceiver ]
				                 ifFalse: [ eventReceiver morph ].
			self tryKeepingMenuOpenIfCorresponds: debuggedMorph.
			val := self
				       openDebugSessionForReceiver: receiver
				       onMethod: aMethod
				       eventReceiver: eventReceiver
				       withMorph: debuggedMorph ]
		ifFalse: [ val := receiver withArgs: args executeMethod: aMethod ].
	^ val
]

{ #category : #'as yet unclassified' }
SeekerMouseButtonEventSentToDebugSessionQWPCH class >> tryKeepingMenuOpenIfCorresponds: targetMorph [

	SeekerConfig default keepMenusOpen ifFalse: [ ^ self ].
	targetMorph class switch
		case: MenuMorph do: [ targetMorph stayUp: true ];
		case: SpToggleMenuItemMorph
		do: [ targetMorph selector: #toggleStayUp: ];
		defaultCase: [ self inform: targetMorph class name ]
]
