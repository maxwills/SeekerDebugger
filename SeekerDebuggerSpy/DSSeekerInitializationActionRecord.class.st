Class {
	#name : #DSSeekerInitializationActionRecord,
	#superclass : #DSSeekerActionRecord,
	#instVars : [
		'testClass',
		'testMethodSelector',
		'usingFakeWindow'
	],
	#category : #SeekerDebuggerSpy
}

{ #category : #initialization }
DSSeekerInitializationActionRecord >> initialize [

	usingFakeWindow := false.
	super initialize
]

{ #category : #accessing }
DSSeekerInitializationActionRecord >> testClass [

	^ testClass
]

{ #category : #accessing }
DSSeekerInitializationActionRecord >> testClass: anObject [

	testClass := anObject
]

{ #category : #accessing }
DSSeekerInitializationActionRecord >> testMethodSelector [

	^ testMethodSelector
]

{ #category : #accessing }
DSSeekerInitializationActionRecord >> testMethodSelector: anObject [

	testMethodSelector := anObject
]

{ #category : #accessing }
DSSeekerInitializationActionRecord >> usingFakeWindow [

	^ usingFakeWindow
]

{ #category : #accessing }
DSSeekerInitializationActionRecord >> usingFakeWindow: anObject [

	usingFakeWindow := anObject
]
