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

	r1 := aRandom nextIntegerBetween: 1 and: activityNamesPrefixArray size.
	r2 := aRandom nextIntegerBetween: 1 and: activityNamesSufixArray size.
	^ (activityNamesPrefixArray at: r1) , (activityNamesSufixArray at: r2)
]

{ #category : #adding }
TownEventActivity >> addParticipants: aCollection [

	aCollection do: [ :p | participants add: p ]
]

{ #category : #accessing }
TownEventActivity >> doExchangeBetween: participant1 and: participant2 withRandom: aRandom [

	| nToExchange applesOfP1 applesOfP2 |
	nToExchange := aRandom nextIntegerBetween: 1 and: (participant1 basket size min: participant2 basket size).
	applesOfP1 := participant1 takeNApples: nToExchange random: aRandom.
	applesOfP2 := participant2 takeNApples: nToExchange random: aRandom.
	participant1 receiveApples: applesOfP2.
	participant2 receiveApples: applesOfP1.
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

{ #category : #printing }
TownEventActivity >> printOn: aStream [

	aStream nextPutAll: 'anActivity: (' , name asString , ')'
]

{ #category : #accessing }
TownEventActivity >> start: random [

	"Exchange apples, change status"

	| pairs |
	pairs := OrderedCollection new.
	1 to: participants size do: [ :i | 
		i + 1 to: participants size do: [ :k | 
			pairs add: { 
					(participants at: i).
					(participants at: k) } ] ].
	pairs do: [ :pair | 
		| p1 p2 |
		p1 := pair at: 1.
		p2 := pair at: 2.
		self doExchangeBetween: p1 and: p2 withRandom: random.
		p1 changeStatus: random.
		p2 changeStatus: random ]
]
