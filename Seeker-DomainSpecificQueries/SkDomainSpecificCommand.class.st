"
Simple command interface for domain-specific queries commands.
My subclasses must implement the subclasses responsibilities of my super classes on the instance side, and the `query` method that returns the query to execute in my class side.
"
Class {
	#name : #SkDomainSpecificCommand,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-DomainSpecificQueries'
}

{ #category : #accessing }
SkDomainSpecificCommand class >> query [
	^self subclassResponsibility 
]

{ #category : #executing }
SkDomainSpecificCommand >> executeCommand [

	self showResultFor:
		(self class query queryFrom: self tracer newProgramStates)
]

{ #category : #accessing }
SkDomainSpecificCommand >> icon [

	^ #smallExport
]
