"
This will be removed. Use execution data queries instead
"
Class {
	#name : #SkObjectAlias,
	#superclass : #Object,
	#instVars : [
		'stepIndex',
		'objectClass',
		'seeker'
	],
	#category : #'Seeker-Deprecated'
}

{ #category : #'instance creation' }
SkObjectAlias class >> newAtStep: aNumber [

	| alias |
	alias := self new.
	alias stepIndex: aNumber.
	^ alias
]

{ #category : #accessing }
SkObjectAlias class >> newForFirstInstanceOf: aClass [ 
"FOR DISPLAY ONLY. TO BE IMPLEMENTED"
]

{ #category : #accessing }
SkObjectAlias class >> newFromCondition: aBlock [ 
"Each step, the Condition block (A block without arguments) is evaluated. The aliased object is the one that first makes the block result not nil"
"FOR DISPLAY ONLY. TO BE IMPLEMENTED"
]

{ #category : #converting }
SkObjectAlias >> asCode [

	^ '(SkObjectAlias newAtStep: ' , self stepIndex asString , ')'
]

{ #category : #'as yet unclassified' }
SkObjectAlias >> getObject [
 ^seeker tracer getObject: self
]

{ #category : #accessing }
SkObjectAlias >> objectClass [

	^ objectClass
]

{ #category : #accessing }
SkObjectAlias >> objectClass: anObject [

	objectClass := anObject
]

{ #category : #accessing }
SkObjectAlias >> seeker [

	^ seeker
]

{ #category : #accessing }
SkObjectAlias >> seeker: anObject [

	seeker := anObject
]

{ #category : #accessing }
SkObjectAlias >> stepIndex [

	^ stepIndex
]

{ #category : #accessing }
SkObjectAlias >> stepIndex: anObject [

	stepIndex := anObject
]
