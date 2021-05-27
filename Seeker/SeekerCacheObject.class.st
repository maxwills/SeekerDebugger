"
Used for 'extending' object without the need of modifying their class definition.
Holds weak identity key dictionaries with the the extended propertied of any object. The object needs to be able to understan ""class"" message.
Useful when in need of new instance variables for objects that can't be modified (for example, context, RBNodes, etc).
Write your extension method for those object, and use this class to be able for the new ""extended instance variables"".

Example:

|context|
context := thisContext.
ExtendedProperties on: context at: 'newInstanceVariable' put: 'Hello'
"
Class {
	#name : #SeekerCacheObject,
	#superclass : #Object,
	#instVars : [
		'weakRefs'
	],
	#category : #'Seeker-SeekerCache'
}

{ #category : #'instance creation' }
SeekerCacheObject class >> newFor: anObject [

	| oe |
	oe := self new.
	oe source: anObject.
	^ oe
]

{ #category : #initialization }
SeekerCacheObject >> initialize [

	"
Reference listlist: 
1: source object.
2: seeker tracer
"

	weakRefs := WeakArray new: 2
]

{ #category : #'as yet unclassified' }
SeekerCacheObject >> source [

	^ weakRefs at: 1
]

{ #category : #'as yet unclassified' }
SeekerCacheObject >> source: anObj [

	weakRefs at: 1 put: anObj
]

{ #category : #'as yet unclassified' }
SeekerCacheObject >> tracer [

	^ weakRefs at: 2
]

{ #category : #'as yet unclassified' }
SeekerCacheObject >> tracer: anObj [

	weakRefs at: 2 put: anObj
]
