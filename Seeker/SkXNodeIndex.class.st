Class {
	#name : #SkXNodeIndex,
	#superclass : #Object,
	#instVars : [
		'index'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #'as yet unclassified' }
SkXNodeIndex >> findIn: aCompiledCode [

	^ self subclassResponsibility
]

{ #category : #accessing }
SkXNodeIndex >> index [

	^ index
]

{ #category : #accessing }
SkXNodeIndex >> index: anObject [

	index := anObject
]

{ #category : #testing }
SkXNodeIndex >> isBytecode [

	^ false
]

{ #category : #testing }
SkXNodeIndex >> isStatement [

	^ false
]
