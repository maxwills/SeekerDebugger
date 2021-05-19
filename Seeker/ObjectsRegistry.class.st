Class {
	#name : #ObjectsRegistry,
	#superclass : #Object,
	#instVars : [
		'blocksCollection'
	],
	#category : #'Seeker-Deprecated'
}

{ #category : #adding }
ObjectsRegistry >> addObject: anObject toStepIndex: aNumber [
	blocksCollection add: { anObject . aNumber . ((blocksCollection size) + 1)}
]

{ #category : #adding }
ObjectsRegistry >> clear [ 
blocksCollection := OrderedCollection new.
]

{ #category : #adding }
ObjectsRegistry >> containsObject: anObject [
	^ (self getObjectIndexInRegistry: anObject)>0
]

{ #category : #adding }
ObjectsRegistry >> containsObjectsInStep: aNumber [
	blocksCollection select: [ :each| ((each at: 2) =aNumber ) ifTrue:[^true] ].
	^false
]

{ #category : #adding }
ObjectsRegistry >> createLabelForObject: anObject [
	blocksCollection do: [ :each | 
		(each at: 1) = anObject ifTrue: [
			|stepIndex|
			stepIndex := each at: 2.
			 ^ 'B', stepIndex asString] ].
]

{ #category : #adding }
ObjectsRegistry >> getCreationStepOfObject: anObject [
	blocksCollection do: [ :each| ((each at: 1) = anObject ) ifTrue:[^each at: 2] ].
	^0
]

{ #category : #adding }
ObjectsRegistry >> getObjectAtStep: aNumber [

	blocksCollection do: [ :each | 
		(each at: 2) = aNumber ifTrue: [ ^ each at: 1 ] ].
	^ nil
]

{ #category : #'as yet unclassified' }
ObjectsRegistry >> getObjectIndexInRegistry: anObject [

	| count |
	count := 0.
	blocksCollection do: [ :each | 
		count := count + 1.
		(each at: 1) = anObject ifTrue: [ ^ count ] ].
	^ 0
]

{ #category : #'as yet unclassified' }
ObjectsRegistry >> getStepOfObject: anObject [

	| objectRegIndex objectReg |
	objectRegIndex := self getObjectIndexInRegistry: anObject.
	objectReg := blocksCollection at: objectRegIndex.
	^ objectReg at: 2
]

{ #category : #initialization }
ObjectsRegistry >> initialize [

	blocksCollection := OrderedCollection new.
]
