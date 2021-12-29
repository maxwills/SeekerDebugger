"
A general purpose wrapper. The method is wrapped, and the handling logic is ultimately decided by the handler itself.
Normally used for prototyping untill a stable wrapper is defined. Then, it might be better to create a specific QuickWrapPostCompilationHandler.

It is not adviced to use this wrapper. The reason is that a wrapper should keep a close relation with the wrapped method to properly the wrapped object API. Just be careful when using this.
"
Class {
	#name : #SeekerSmartInterceptQWPCH,
	#superclass : #QwPostCompilationHandler,
	#category : #'Seeker-ActivePragmas'
}

{ #category : #'as yet unclassified' }
SeekerSmartInterceptQWPCH class >> handleCompiledMethod: aMethod [

	"This is called by the quickWrap system if the method pragmas contains the pragma of this class"

	| proxy |
	proxy := QuickWrapMethodProxy
		         onMethod: aMethod
		         delegateHandler: [ SeekerSmartInterceptQWPCH ]
		         selector: #seekerSmartInterceptWrapper:method:arguments:.
	proxy install
]

{ #category : #'as yet unclassified' }
SeekerSmartInterceptQWPCH class >> handledPragma [

	^ #seekerSmartIntercept
]

{ #category : #'as yet unclassified' }
SeekerSmartInterceptQWPCH class >> seekerSmartInterceptWrapper: receiver method: method arguments: args [

	| val |
	val := receiver withArgs: args executeMethod: method.

	^ val
]
