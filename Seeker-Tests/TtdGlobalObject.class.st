Class {
	#name : #TtdGlobalObject,
	#superclass : #TestCase,
	#instVars : [
		'val'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #accessing }
TtdGlobalObject >> val [

	^ val
]

{ #category : #accessing }
TtdGlobalObject >> val: anObject [

	val := anObject
]
