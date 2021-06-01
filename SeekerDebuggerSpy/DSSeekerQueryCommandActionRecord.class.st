Class {
	#name : #DSSeekerQueryCommandActionRecord,
	#superclass : #DSSeekerDetailedActionRecord,
	#instVars : [
		'queryCommandClass',
		'subEvent'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #accessing }
DSSeekerQueryCommandActionRecord >> queryCommandClass [

	^ queryCommandClass
]

{ #category : #accessing }
DSSeekerQueryCommandActionRecord >> queryCommandClass: anObject [

	queryCommandClass := anObject
]

{ #category : #accessing }
DSSeekerQueryCommandActionRecord >> subEvent [

	^ subEvent
]

{ #category : #accessing }
DSSeekerQueryCommandActionRecord >> subEvent: anObject [

	subEvent := anObject
]
