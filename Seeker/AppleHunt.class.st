Class {
	#name : #AppleHunt,
	#superclass : #Object,
	#instVars : [
		'hunters',
		'random'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #'as yet unclassified' }
AppleHunt class >> letItBegin [

	| a winner |
	a := AppleHunt new.
	a giveHuntersSomeBags.
	a goHunting.
	winner := a calculateRanks first.
	winner biggestBagSize
]

{ #category : #'as yet unclassified' }
AppleHunt >> calculateRanks [

	| ranked |
	ranked := SortedCollection sortUsing: [ :h1 :h2 | h1 biggestBagSize > h2 biggestBagSize ].
	hunters valuesDo: [ :hunter | ranked add: hunter ].
	^ ranked
]

{ #category : #'as yet unclassified' }
AppleHunt >> doHuntingStage: stageNumber [

	| maxApples |
	maxApples := 10 * stageNumber.

	hunters valuesDo: [ :hunter | 
		| huntedApples |
		huntedApples := random nextIntegerBetween: 1 and: maxApples.
		huntedApples timesRepeat: [ hunter storeAnAppleInRandomBag: random ] ]
]

{ #category : #'as yet unclassified' }
AppleHunt >> giveHuntersSomeBags [

	| maxBags |
	maxBags := 5.
	"Give hunter some bags"
	hunters valuesDo: [ :hunter | hunter assignBags: (random nextIntegerBetween: 1 and: maxBags) ].
	
	
]

{ #category : #'as yet unclassified' }
AppleHunt >> goHunting [

	| nTimes |
	nTimes := 4. 
	1 to: nTimes do: [ :i | 
		self doHuntingStage: i]
]

{ #category : #accessing }
AppleHunt >> hunters [

	^ hunters
]

{ #category : #accessing }
AppleHunt >> hunters: anObject [

	hunters := anObject
]

{ #category : #initialization }
AppleHunt >> initialize [

	random := self newRandom.
	hunters := { 
		           (#Alice -> AppleHunter newAlice).
		           (#Bob -> AppleHunter newBob).
		           (#Charlie -> AppleHunter newCharlie) } asDictionary
]

{ #category : #initialization }
AppleHunt >> newRandom [

	^ Random new
		  seed: 1;
		  yourself
]
