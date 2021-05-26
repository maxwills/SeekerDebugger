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
	#name : #ObjectExtension,
	#superclass : #Object,
	#instVars : [
		'sourceObjWeakRef'
	],
	#classInstVars : [
		'dictionary'
	],
	#category : #'Seeker-ObjectExtensions'
}

{ #category : #accessing }
ObjectExtension class >> allObjects [

	^ dictionary ifNil: [ 
		  dictionary := WeakIdentityKeyDictionary new ]
]

{ #category : #'instance creation' }
ObjectExtension class >> newFor: anObject [

	| oe |
	oe := self new.
	oe source: anObject.
	^ oe
]

{ #category : #'as yet unclassified' }
ObjectExtension class >> propertiesOf: anObject [

	^ self allObjects
		  at: anObject
		  ifAbsentPut: [ 
		  anObject defaultObjectExtensionClass newFor: anObject ]
]

{ #category : #initialization }
ObjectExtension class >> reset [ 
	dictionary := WeakIdentityKeyDictionary new.
]

{ #category : #initialization }
ObjectExtension >> initialize [

	sourceObjWeakRef := WeakArray new: 1
]

{ #category : #'as yet unclassified' }
ObjectExtension >> source [

	^ sourceObjWeakRef at: 1
]

{ #category : #'as yet unclassified' }
ObjectExtension >> source: anObj [

	sourceObjWeakRef at: 1 put: anObj
]
