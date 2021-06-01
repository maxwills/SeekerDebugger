Class {
	#name : #DSSeekerActionRecord,
	#superclass : #DSAbstractEventRecord,
	#instVars : [
		'eventName',
		'seekerInstanceID'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #'as yet unclassified' }
DSSeekerActionRecord class >> newEmptyRecordHolder [

	| c superVars d |
	superVars := DSAbstractEventRecord allInstVarNames asSet.
	c := OrderedCollection new.
	self allInstVarNames do: [ :v | 
		(superVars includes: v) ifFalse: [ c add: v asSymbol -> '#-' ] ].
	d := c asDictionary asAnonymousType.
	d at: #win put: #-.
	^ d
]

{ #category : #accessing }
DSSeekerActionRecord >> eventName [
	^ eventName
]

{ #category : #accessing }
DSSeekerActionRecord >> eventName: anObject [

	eventName := anObject
]

{ #category : #'actions api' }
DSSeekerActionRecord >> oldRecord: aSeekerQuery [

super record: aSeekerQuery seekerDebuggerPresenter window window.
eventName := aSeekerQuery class name.

]

{ #category : #'actions api' }
DSSeekerActionRecord >> record: object [

	| superVars |
	object win ifNotNil: [ 
		(object win class inheritsFromOrSameAs: SpWindow) ifTrue: [ 
			super record: object win ] ].
	superVars := DSAbstractEventRecord allInstVarNames asSet.
	self class allInstVarNames do: [ :v | 
		(superVars includes: v) ifFalse: [ 
			self instVarNamed: v put: (object at: v) ] ]
]

{ #category : #accessing }
DSSeekerActionRecord >> seekerInstanceID [

	^ seekerInstanceID
]

{ #category : #accessing }
DSSeekerActionRecord >> seekerInstanceID: anObject [

	seekerInstanceID := anObject
]
