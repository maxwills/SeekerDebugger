Class {
	#name : #Villager,
	#superclass : #Object,
	#instVars : [
		'name',
		'age',
		'basket',
		'status'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #'as yet unclassified' }
Villager class >> newAlice [

	^ self new
		  name: #Alice;
		  age: 20;
		  yourself
]

{ #category : #'as yet unclassified' }
Villager class >> newBob [

	^ self new
		  name: #Bob;
		  age: 30;
		  yourself
]

{ #category : #'as yet unclassified' }
Villager class >> newCharlie [

	^ self new
		  name: #Charlie;
		  age: 40;
		  yourself
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
Villager >> basket [

	^ basket
]

{ #category : #'as yet unclassified' }
Villager >> changeStatus: random [

	status := { #ok. #happy. #bored } at: (random nextIntegerBetween: 1 and: 3)
]

{ #category : #'as yet unclassified' }
Villager >> eatAllApples [

	basket copy do: [ :apple | 
		basket remove: apple.
		self eatApple: apple ]
]

{ #category : #'as yet unclassified' }
Villager >> eatApple: apple [

	apple healthy ifFalse: [ status := #kia ]
]

{ #category : #comparing }
Villager >> hash [

	^ name hash
]

{ #category : #initialization }
Villager >> initialize [

	name := 'Unknown'.
	age := 0.
	basket := OrderedCollection new.
	status := #ok
]

{ #category : #accessing }
Villager >> name [

	^ name
]

{ #category : #accessing }
Villager >> name: anObject [

	name := anObject
]

{ #category : #printing }
Villager >> printOn: aStream [

	aStream
		nextPutAll: name asString;
		nextPutAll: '(';
		nextPutAll: age asString;
		nextPutAll: ')'";
		nextPutAll: status asString"
]

{ #category : #'as yet unclassified' }
Villager >> receiveApples: aCollection [

	aCollection do: [ :apple | basket add: apple ]
]

{ #category : #accessing }
Villager >> status [

	^ status
]

{ #category : #accessing }
Villager >> status: anObject [

	status := anObject
]

{ #category : #'as yet unclassified' }
Villager >> takeNApples: aNumber random: random [

	"takes aNumber Apples randomly selected from the basket. removes them from the basket, and returns them"

	| selectedApples |
	selectedApples := OrderedCollection new.
	1 to: aNumber do: [ :i | 
		| randomIndex apple |
		randomIndex := random nextIntegerBetween: 1 and: basket size.
		apple := basket at: randomIndex.
		basket removeAt: randomIndex.
		selectedApples add: apple ].
	^ selectedApples
]
