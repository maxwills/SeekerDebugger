Class {
	#name : #CreateSeekerDebugSession,
	#superclass : #QwPostCompilationHandler,
	#category : #'Seeker-Annotations'
}

{ #category : #'as yet unclassified' }
CreateSeekerDebugSession class >> handleCompiledMethod: aMethod [

	"This is called by the quickWrap system if the method pragmas contains the pragma of this class"

	| proxy |
	proxy := QuickWrapMethodProxy
		         onMethod: aMethod
		         delegateHandler: [ SeekerSessionHelpers ]
		         selector: #seekerSessionWrapper:method:arguments:.
	proxy install
]

{ #category : #'as yet unclassified' }
CreateSeekerDebugSession class >> handledPragma [

	^ #seekerDebugSessionHere
]
