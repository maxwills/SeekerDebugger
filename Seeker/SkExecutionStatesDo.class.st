Class {
	#name : #SkExecutionStatesDo,
	#superclass : #Object,
	#classInstVars : [
		'lastExecutionStatesDo'
	],
	#category : #'Seeker-Query'
}

{ #category : #accessing }
SkExecutionStatesDo class >> lastExecutionStatesDo [

	^ lastExecutionStatesDo
]

{ #category : #accessing }
SkExecutionStatesDo class >> lastExecutionStatesDo: anObject [

	lastExecutionStatesDo := anObject
]

{ #category : #accessing }
SkExecutionStatesDo >> action: state [

	^ self
]

{ #category : #initialization }
SkExecutionStatesDo >> initialize [

	self class lastExecutionStatesDo: self
]

{ #category : #accessing }
SkExecutionStatesDo >> selection: state [

	^ true
]
