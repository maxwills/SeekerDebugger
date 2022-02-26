Class {
	#name : #TownEvent,
	#superclass : #Object,
	#instVars : [
		'name',
		'population',
		'activities',
		'random',
		'applesPool'
	],
	#category : #'Seeker-Presentation'
}

{ #category : #accessing }
TownEvent class >> applesPerParticipant [

	^ 4
]

{ #category : #'as yet unclassified' }
TownEvent class >> numberOfActivities [

^ 3
]

{ #category : #accessing }
TownEvent class >> numberOfParticipants [

	^ 3
]

{ #category : #accessing }
TownEvent class >> totalApples [

	^ self numberOfParticipants * self applesPerParticipant
]

{ #category : #accessing }
TownEvent >> activities [

	^ activities
]

{ #category : #accessing }
TownEvent >> activities: anObject [

	activities := anObject
]

{ #category : #'as yet unclassified' }
TownEvent >> createActivity [

	^ TownEventActivity new
		  name: (TownEventActivity  createRandomActivityName: random);
		  yourself
]

{ #category : #initialization }
TownEvent >> initialize [

	name := 'Unnamed town event'.
	population := IdentitySet new.
	activities := OrderedCollection new.
	random := self initializeRandom.
	applesPool := IdentitySet new.
]

{ #category : #initialization }
TownEvent >> initializeRandom [

	^ Random new
		  seed: 1;
		  yourself
]

{ #category : #accessing }
TownEvent >> name [

	^ name
]

{ #category : #accessing }
TownEvent >> name: anObject [

	name := anObject
]

{ #category : #accessing }
TownEvent >> organizeEvent [

	| nActivities totalApples |
	totalApples := self class totalApples .
	nActivities := self class numberOfActivities.
	
	1 to: totalApples - 1 do: [ :i | applesPool add: Apple new ].
	applesPool add: (Apple new
			 healthy: false;
			 yourself).
			
	1 to: nActivities do: [ :i| activities add: TownEventActivity new ]
]

{ #category : #'as yet unclassified' }
TownEvent >> populate [

]

{ #category : #accessing }
TownEvent >> population [

	^ population
]

{ #category : #accessing }
TownEvent >> population: anObject [

	population := anObject
]

{ #category : #accessing }
TownEvent >> random [

	^ random
]

{ #category : #accessing }
TownEvent >> random: anObject [

	random := anObject
]

{ #category : #accessing }
TownEvent >> start [
	
	activities do: [ :activity | activity start ].
]
