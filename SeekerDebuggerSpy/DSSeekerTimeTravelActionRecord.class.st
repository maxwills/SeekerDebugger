Class {
	#name : #DSSeekerTimeTravelActionRecord,
	#superclass : #DSSeekerActionRecord,
	#instVars : [
		'selectedResult'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #accessing }
DSSeekerTimeTravelActionRecord >> selectedResult [

	^ selectedResult
]

{ #category : #accessing }
DSSeekerTimeTravelActionRecord >> selectedResult: anObject [

	selectedResult := anObject
]
