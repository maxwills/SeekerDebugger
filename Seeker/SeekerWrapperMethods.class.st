Class {
	#name : #SeekerWrapperMethods,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerWrapperMethods class >> handMorphHandleEventWrapper: receiver method: method arguments: arguments [

	| event |
	event := arguments first.
	receiver owner ifNotNil: [ 
		SeekerGlobals instance updateModifierKeys: event ].
	^ receiver execute: method withArgs: arguments
]
