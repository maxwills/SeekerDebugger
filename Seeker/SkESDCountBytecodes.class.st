Class {
	#name : #SkESDCountBytecodes,
	#superclass : #SkExecutionStatesDo,
	#instVars : [
		'count'
	],
	#category : #'Seeker-Query'
}

{ #category : #initialization }
SkESDCountBytecodes >> action: state [

	count := count + 1
]

{ #category : #accessing }
SkESDCountBytecodes >> count [

	^ count
]

{ #category : #accessing }
SkESDCountBytecodes >> count: anObject [

	count := anObject
]

{ #category : #initialization }
SkESDCountBytecodes >> initialize [

	super initialize.
	count := 0
]
