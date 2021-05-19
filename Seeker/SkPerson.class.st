Class {
	#name : #SkPerson,
	#superclass : #Object,
	#instVars : [
		'name',
		'age',
		'pets'
	],
	#category : #'Seeker-BugCollection-Tests'
}

{ #category : #operations }
SkPerson >> adopt: aSkDog [
	pets add: aSkDog
]

{ #category : #accessing }
SkPerson >> age [

	^ age
]

{ #category : #accessing }
SkPerson >> age: anObject [

	age := anObject
]

{ #category : #testing }
SkPerson >> findPet: aBlock [
	pets anySatisfy: aBlock
]

{ #category : #initialization }
SkPerson >> initialize [
	pets := OrderedCollection new.
]

{ #category : #accessing }
SkPerson >> name [

	^ name
]

{ #category : #accessing }
SkPerson >> name: anObject [

	name := anObject
]

{ #category : #accessing }
SkPerson >> pets [

	^ pets
]

{ #category : #accessing }
SkPerson >> pets: anObject [

	pets := anObject
]
