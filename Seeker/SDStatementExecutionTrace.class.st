"
Should be a StatementStepDescriptor list.
SSDescriptor list.
"
Class {
	#name : #SDStatementExecutionTrace,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Components'
}

{ #category : #converting }
SDStatementExecutionTrace >> asString [
	| str |
	str := Character cr join: (self collect: [ :eachStepDescriptor | eachStepDescriptor asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ str
]
