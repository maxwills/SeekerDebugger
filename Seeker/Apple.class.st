Class {
	#name : #Apple,
	#superclass : #Object,
	#instVars : [
		'healthy'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #accessing }
Apple >> healthy [

	^ healthy
]

{ #category : #accessing }
Apple >> healthy: anObject [

	healthy := anObject
]

{ #category : #initialization }
Apple >> initialize [

	healthy := true
]
