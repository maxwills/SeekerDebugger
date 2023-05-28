Class {
	#name : #TtdGlobalObject,
	#superclass : #TestCase,
	#instVars : [
		'val'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #converting }
TtdGlobalObject >> asString [

	^ val asString
]

{ #category : #converting }
TtdGlobalObject >> printString [

	^ val asString
]

{ #category : #accessing }
TtdGlobalObject >> val [

	^ val
]

{ #category : #accessing }
TtdGlobalObject >> val: anObject [

	val := anObject
]
