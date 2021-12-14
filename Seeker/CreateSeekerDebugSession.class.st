Class {
	#name : #CreateSeekerDebugSession,
	#superclass : #QwPostCompilationHandler,
	#category : #Seeker
}

{ #category : #'as yet unclassified' }
CreateSeekerDebugSession class >> handleCompiledMethod: aMethod [

	"This is called by the quickWrap system if the method pragmas contains the prama of this class"

	| proxy pragma wrapperClassName wrapperSelector |
	pragma := (aMethod pragmas select: [ :p | 
		           p selector = self handledPragma ]) first.

	wrapperClassName := pragma arguments first.
	wrapperSelector := pragma arguments second.

	proxy := QuickWrapMethodProxy
		         onMethod: aMethod
		         delegateHandler: [ self class environment at: wrapperClassName ]
		         selector: wrapperSelector.
	proxy install
]

{ #category : #'as yet unclassified' }
CreateSeekerDebugSession class >> handledPragma [

	^ #seekerDebugSessionHere
]
