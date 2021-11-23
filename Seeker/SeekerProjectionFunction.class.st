Class {
	#name : #SeekerProjectionFunction,
	#superclass : #Object,
	#instVars : [
		'autoType'
	],
	#category : #'Seeker-Projections'
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

{ #category : #accessing }
SeekerProjectionFunction >> itemClass [

	self value: AutoDummyObject new "Forces a materialization of the autoType, by executing the value: method once".
	^ autoType type
]

{ #category : #accessing }
SeekerProjectionFunction >> value: state [

	"^ state"

	^ self subclassResponsibility
]
