Class {
	#name : #SeekerKeyConditionDebugSessionQWPCH,
	#superclass : #QwPostCompilationHandler,
	#category : #'Seeker-ActivePragmas'
}

{ #category : #'as yet unclassified' }
SeekerKeyConditionDebugSessionQWPCH class >> handleCompiledMethod: aMethod [

	"This is called by the quickWrap system if the method pragmas contains the pragma of this class"

	| proxy |
	proxy := QuickWrapMethodProxy
		         onMethod: aMethod
		         delegateHandler: [ SeekerSessionHelpers ]
		         selector: #seekerKeyConditionSessionWrapper:method:arguments:.
	proxy install
]

{ #category : #'as yet unclassified' }
SeekerKeyConditionDebugSessionQWPCH class >> handledPragma [

	<qwpAddPragmaToAutocompletionIn:
	#SeekerActivePragmasAutocompletionHelper>
	^ #skpDebugWithSeekerIfKeysPressed
]
