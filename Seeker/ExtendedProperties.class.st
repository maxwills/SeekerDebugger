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
	#name : #ExtendedProperties,
	#superclass : #Object,
	#classInstVars : [
		'allPropertiesDictionary'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
ExtendedProperties class >> allPropertiesDictionary [

	^ allPropertiesDictionary ifNil: [ 
		  allPropertiesDictionary := WeakIdentityKeyDictionary new ]
]

{ #category : #'as yet unclassified' }
ExtendedProperties class >> assocOn: anObject at: propName [

	^ (self propertiesOf: anObject) associationAt: propName ifAbsent: [ 
		  | objProp |
		  objProp := self propertiesOf: anObject.
		  objProp at: propName put: nil.
		  ^ objProp associationAt: propName ]
]

{ #category : #'as yet unclassified' }
ExtendedProperties class >> on: anObject at: propName [

	^ (self propertiesOf: anObject) at: propName ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
ExtendedProperties class >> on: anObject at: propName put: value [

	anObject ifNil: [ ^ self error: 'properties of nil not supported' ].
	^ (self propertiesOf: anObject) at: propName put: value
]

{ #category : #'as yet unclassified' }
ExtendedProperties class >> propertiesOf: anObject [

	| objClass classDictionary |
	objClass := anObject class.
	classDictionary := self allPropertiesDictionary
		                   at: objClass
		                   ifAbsentPut: [ WeakIdentityKeyDictionary new ].
	^ classDictionary
		  at: anObject
		  ifAbsentPut: [ WeakIdentityKeyDictionary new ]
]

{ #category : #initialization }
ExtendedProperties class >> reset [ 
	allPropertiesDictionary := WeakIdentityKeyDictionary new.
]

{ #category : #initialization }
ExtendedProperties >> initialize [ 

]
