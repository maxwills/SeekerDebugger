Class {
	#name : #SeekerProjectionFunction,
	#superclass : #Object,
	#instVars : [
		'autoType'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'field definition' }
SeekerProjectionFunction >> fields [

	"Obtained from the autoType"

	^ self itemClass fields
]

{ #category : #initialization }
SeekerProjectionFunction >> initialize [

	autoType := AutoType new
]

{ #category : #testing }
SeekerProjectionFunction >> isIdentity [

	^ false
]

{ #category : #accessing }
SeekerProjectionFunction >> itemClass [

	self value: AutoTypeDummyObject new "Forces a materialization of the autoType, by executing the value: method once".
	^ autoType type
]

{ #category : #accessing }
SeekerProjectionFunction >> value: state [

	"^ state"

	^ self subclassResponsibility
]
