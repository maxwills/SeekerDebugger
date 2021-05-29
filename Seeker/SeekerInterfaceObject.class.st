"
Base class for Seeker Interfaces

Seeker Interfaces are objects that expose a set of conceptually related methods.

Some interfaces can be used to find specific objects in the debugged program execution, other for time travel, and more.
See each interface object description for details.
"
Class {
	#name : #SeekerInterfaceObject,
	#superclass : #Object,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-Interfaces'
}

{ #category : #accessing }
SeekerInterfaceObject >> tracer [

	^ tracer
]

{ #category : #accessing }
SeekerInterfaceObject >> tracer: anObject [

	tracer := anObject
]
