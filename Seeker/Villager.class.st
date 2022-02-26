Class {
	#name : #Villager,
	#superclass : #Object,
	#instVars : [
		'name',
		'age',
		'basquet'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #adding }
Villager >> add: anObject [

	"Adds an object to the basquet"

	basquet add: anObject
]

{ #category : #accessing }
Villager >> age [

	^ age
]

{ #category : #accessing }
Villager >> age: anObject [

	age := anObject
]

{ #category : #accessing }
Villager >> basquet [

	^ basquet
]

{ #category : #accessing }
Villager >> basquet: anObject [

	basquet := anObject
]

{ #category : #initialization }
Villager >> initialize [

	name := 'Unknown'.
	age := 0.
	basquet := OrderedCollection new
]

{ #category : #accessing }
Villager >> name [

	^ name
]

{ #category : #accessing }
Villager >> name: anObject [

	name := anObject
]
