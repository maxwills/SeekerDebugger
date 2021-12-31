Class {
	#name : #SeekerCounter,
	#superclass : #Object,
	#instVars : [
		'count'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerCounter class >> countTo: aNumber [

	^ self new count: aNumber
]

{ #category : #accessing }
SeekerCounter >> count: aNumber [

	count := aNumber
]

{ #category : #accessing }
SeekerCounter >> value [

	count := count - 1.
	^ count <= 0
]

{ #category : #controlling }
SeekerCounter >> whileFalse: aBlock [

	^ [ self value ] whileFalse: aBlock
]

{ #category : #controlling }
SeekerCounter >> whileTrue: aBlock [

	^ [ self value ] whileTrue: aBlock
]
