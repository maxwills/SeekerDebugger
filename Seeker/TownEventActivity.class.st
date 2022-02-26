Class {
	#name : #TownEventActivity,
	#superclass : #Object,
	#instVars : [
		'name',
		'participants'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #'as yet unclassified' }
TownEventActivity class >> createRandomActivityName: aRandom [

	| activityNamesPrefixArray activityNamesSufixArray r1 r2 |
	activityNamesPrefixArray := { 'Day of '. 'Anything but '. 'Please, no more '. 'I am ok with ' }.
	activityNamesSufixArray := { 'eating'. 'doing sport'. 'being happy'. 'whatever' }.

	r1 := aRandom nextBetween: 1 and: activityNamesPrefixArray size.
	r2 := aRandom nextBetween: 1 and: activityNamesSufixArray size.
	^ (activityNamesPrefixArray at: r1) + (activityNamesSufixArray at: r2)
]

{ #category : #initialization }
TownEventActivity >> initialize [

	participants := OrderedCollection new.
	name := 'unnamed Activity'.
]

{ #category : #accessing }
TownEventActivity >> name [

	^ name
]

{ #category : #accessing }
TownEventActivity >> name: anObject [

	name := anObject
]

{ #category : #accessing }
TownEventActivity >> participants [

	^ participants
]

{ #category : #accessing }
TownEventActivity >> participants: anObject [

	participants := anObject
]
