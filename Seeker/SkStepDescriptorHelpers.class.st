Class {
	#name : #SkStepDescriptorHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
SkStepDescriptorHelpers class >> descriptor: aStepDescriptor containsSequenceByMethod: aMethod reverseSearchStartingAt: aNumber [

	"returns true if any of the sequence (starting at aNumber) in this path matches the method. Returns false otherwise. aMethod is a compiledMethod (example: Object>>#release)"

	| receiverClass methodSelector |
	aNumber < 1 ifTrue: [ ^ false ].
	aNumber > aStepDescriptor size ifTrue: [ ^ false ].
	receiverClass := aMethod methodClass.
	methodSelector := aMethod selector.
	(1 to: aNumber) reverseDo: [ :index | 
		| sequenceID |
		sequenceID := (aStepDescriptor at: aNumber) sequenceStaticID.
		(sequenceID receiverClass = receiverClass and: [ 
			 sequenceID methodSelector = methodSelector ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
SkStepDescriptorHelpers class >> descriptor: aStepDescriptor containsSequenceByMethod: aMethod startingAt: aNumber [

	"returns true if any of the sequence (starting at aNumber) in this path matches the method. Returns false otherwise. aMethod is a compiledMethod (example: Object>>#release)"

	| receiverClass methodSelector |
	aNumber < 1 ifTrue: [ ^ false ].
	aNumber > aStepDescriptor size ifTrue: [ ^ false ].
	receiverClass := aMethod methodClass.
	methodSelector := aMethod selector.
	aNumber to: aStepDescriptor size do: [ :index | 
		| sequenceID |
		sequenceID := (aStepDescriptor at: aNumber) sequenceStaticID.
		(sequenceID receiverClass = receiverClass and: [ 
			 sequenceID methodSelector = methodSelector ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
SkStepDescriptorHelpers class >> descriptor: aStepDescriptor containsSequenceByMethodSelector: aSymbol andClass: aClass startingAt: aNumber [

	"returns true if any of the sequence (starting at aNumber) in this path matches the method. Returns false otherwise. aMethod is a compiledMethod (example: Object>>#release)"
	| receiverClass methodSelector |
	aNumber < 1 ifTrue: [ ^ false ].
	aNumber > aStepDescriptor size ifTrue: [ ^ false ].
	receiverClass := aClass.
	methodSelector := aSymbol.
	aNumber to: aStepDescriptor size do: [ :index | 
		| sequenceID |
		sequenceID := (aStepDescriptor at: aNumber) sequenceStaticID.
		(sequenceID receiverClass = receiverClass and: [ 
			 sequenceID methodSelector = methodSelector ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
SkStepDescriptorHelpers class >> descriptor: aStepDescriptor containsSequenceByMethodSelector: aSymbol startingAt: aNumber [

	"returns true if any of the sequence (starting at aNumber) in this path matches the method. Returns false otherwise. aMethod is a compiledMethod (example: Object>>#release)"

	| methodSelector |
	aNumber < 1 ifTrue: [ ^ false ].
	aNumber > aStepDescriptor size ifTrue: [ ^ false ].
	methodSelector := aSymbol.
	aNumber to: aStepDescriptor size do: [ :index | 
		| sequenceID |
		sequenceID := (aStepDescriptor at: index) sequenceStaticID.
		sequenceID methodSelector = methodSelector ifTrue: [ ^ true ] ].
	^ false
]
