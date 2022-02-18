Class {
	#name : #SkNDSHandler,
	#superclass : #Object,
	#instVars : [
		'handledMethods'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkNDSHandler class >> allHandledMethods [

	| allMethods |
	allMethods := Set new.

	self allSubclasses do: [ :sub | sub handledMethods do: [ :m | allMethods add: m ] ].
	^ allMethods
]

{ #category : #'as yet unclassified' }
SkNDSHandler class >> allNDSHandlers [

	^ self allSubclasses collect: [ :sub | sub new ]
]

{ #category : #'as yet unclassified' }
SkNDSHandler class >> handledMethods [

	^ {  }
]

{ #category : #accessing }
SkNDSHandler >> handledMethods [

	^ handledMethods
]

{ #category : #initialization }
SkNDSHandler >> initialize [

	handledMethods := self class handledMethods
]
