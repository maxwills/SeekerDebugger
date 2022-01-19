Class {
	#name : #SeekerExecutionStatesDoQWPCH,
	#superclass : #QwPostCompilationHandler,
	#category : #'Seeker-ActivePragmas'
}

{ #category : #'as yet unclassified' }
SeekerExecutionStatesDoQWPCH class >> handleCompiledMethod: aMethod [

	"This is called by the quickWrap system if the method pragmas contains the pragma of this class"

	| proxy |
	proxy := QuickWrapMethodProxy
		         onMethod: aMethod
		         delegateHandler: [ SeekerSessionHelpers ]
		         selector: #seekerExecutionStatesDoSessionWrapper:method:arguments:.
	proxy install
]

{ #category : #'as yet unclassified' }
SeekerExecutionStatesDoQWPCH class >> handledPragma [

	<qwpAddPragmaToAutocompletionIn:
	#SeekerActivePragmasAutocompletionHelper>
	^ #skpExecutionStatesDo:
]
