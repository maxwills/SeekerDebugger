Class {
	#name : #SeekerDebuggerPlugin,
	#superclass : #Object,
	#instVars : [
		'seeker',
		'methodsHandling'
	],
	#category : #'Seeker-Plugins'
}

{ #category : #'as yet unclassified' }
SeekerDebuggerPlugin >> handleMethod: aSymbol withArguments: args [

	| handlingBlock |
	(seeker class >> aSymbol) argumentNames size = args size ifFalse: [ 
		^ self error: 'Argument''s size mismatch 1' ].
	handlingBlock := methodsHandling at: aSymbol.
	handlingBlock argumentCount = args size ifFalse: [ 
		^ self error: 'Argument''s size mismatch 2' ].
	^ handlingBlock valueWithArguments: args
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPlugin >> handlesMethod: aSymbol [

	^ methodsHandling includesKey: aSymbol
]

{ #category : #initialization }
SeekerDebuggerPlugin >> initialize [

	methodsHandling := Dictionary new
]

{ #category : #initialization }
SeekerDebuggerPlugin >> initializeMethodHandlers [

	"Example"

	"methodsHandling at: #selector:withTwoArgs: put: [:arg1 :arg2: self handleSelector: arg1 withTwoArgs: arg2 ]."

	"Remember to implement that method!"

	^ self subclassResponsibility
]

{ #category : #initialization }
SeekerDebuggerPlugin >> initializeModel: anObject [

	seeker := anObject.
	self initializeMethodHandlers.
]

{ #category : #'as yet unclassified' }
SeekerDebuggerPlugin >> pragmaHolderForPlugins [

	self subclassResponsibility
	"Your subclass must include the pragma below"

	"<seekerDebuggerPlugin:1>"
]

{ #category : #accessing }
SeekerDebuggerPlugin >> seeker [

	^ seeker
]

{ #category : #accessing }
SeekerDebuggerPlugin >> seeker: anObject [

	seeker := anObject
]
