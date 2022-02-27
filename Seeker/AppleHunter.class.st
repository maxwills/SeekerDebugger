Class {
	#name : #AppleHunter,
	#superclass : #Object,
	#instVars : [
		'name',
		'bags'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #'instance creation' }
AppleHunter class >> newAlice [

	^ self new
		  name: #Alice;
		  yourself
]

{ #category : #'instance creation' }
AppleHunter class >> newBob [

	^ self new
		  name: #Bob;
		  yourself
]

{ #category : #'instance creation' }
AppleHunter class >> newCharlie [

	^ self new
		  name: #Charlie;
		  yourself
]

{ #category : #'as yet unclassified' }
AppleHunter >> assignBags: aNumber [

	aNumber timesRepeat: [ bags add: OrderedCollection new ]
]

{ #category : #accessing }
AppleHunter >> bags [

	^ bags
]

{ #category : #accessing }
AppleHunter >> bags: anObject [

	bags := anObject
]

{ #category : #'as yet unclassified' }
AppleHunter >> biggestBagSize [

	| maxSize |
	maxSize := 0.
	bags do: [ :b | maxSize := maxSize max: b size ].
	^ maxSize
]

{ #category : #'as yet unclassified' }
AppleHunter >> countApples [

	| count |
	count := 0.
	count := bags do: [ :b | count := count + b size ].
	^ count
]

{ #category : #initialization }
AppleHunter >> initialize [

	bags := OrderedCollection new
]

{ #category : #accessing }
AppleHunter >> name [

	^ name
]

{ #category : #accessing }
AppleHunter >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
AppleHunter >> storeAnAppleInRandomBag: random [

	| bag |
	bag := bags at: (random nextIntegerBetween: 1 and: bags size).
	bag add: (Apple new
			 id: (random nextIntegerBetween: 1 and: 1000000);
			 yourself)
]
