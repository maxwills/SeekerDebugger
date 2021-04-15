"
Should be a StatementStepDescriptor list.
SSDescriptor list.

(Next paragrah is a mistake. I moved that logic in the stepper and not the trace)
The idea so far is that this trace should contain no references or data at all (other than the minimum aspects of the step descriptors). If any other processing or storing capabilities should be added, the class must be extended, or a dynamic solution should be used (I though about SPUs and Trace queries, but tha approach is too heavy weight (too java like)). 

"
Class {
	#name : #SkTrace,
	#superclass : #OrderedCollection,
	#category : #'Seeker-Trace'
}

{ #category : #converting }
SkTrace >> asString [
	| str |
	str := Character cr join: (self collect: [ :eachStepDescriptor | eachStepDescriptor asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ str
]
