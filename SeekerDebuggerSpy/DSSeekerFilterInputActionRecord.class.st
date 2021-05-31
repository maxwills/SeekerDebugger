Class {
	#name : #DSSeekerFilterInputActionRecord,
	#superclass : #DSSeekerActionRecord,
	#instVars : [
		'filterText'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #accessing }
DSSeekerFilterInputActionRecord >> filterText [

	^ filterText
]

{ #category : #accessing }
DSSeekerFilterInputActionRecord >> filterText: anObject [

	filterText := anObject
]
