Class {
	#name : #SeekerSpMorphicToolbarAdapter,
	#superclass : #SpMorphicToolbarAdapter,
	#category : #'Seeker-UI'
}

{ #category : #accessing }
SeekerSpMorphicToolbarAdapter class >> adaptingName [

	"Override me if adapter will not follow the common pattern"

	"remove 'SpMorphic' part and *in general*, I will have the adapting name"

	^ #SeekerToolbarAdapter
]

{ #category : #factory }
SeekerSpMorphicToolbarAdapter >> buildWidget [

	| toolBarMorph |
	toolBarMorph := SeekerSpToolbarMorph new.
	self addModelTo: toolBarMorph.

	^ toolBarMorph
]

{ #category : #'as yet unclassified' }
SeekerSpMorphicToolbarAdapter >> refreshStyle [

	self applyStyle: self widget
]
