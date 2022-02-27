Class {
	#name : #Apple,
	#superclass : #Object,
	#instVars : [
		'healthy',
		'id'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #comparing }
Apple >> hash [

	^ id
]

{ #category : #accessing }
Apple >> healthy [

	^ healthy
]

{ #category : #accessing }
Apple >> healthy: anObject [

	healthy := anObject
]

{ #category : #accessing }
Apple >> id [

	^ id
]

{ #category : #accessing }
Apple >> id: anObject [

	id := anObject
]

{ #category : #initialization }
Apple >> initialize [

	healthy := true.
	id := 0
]
