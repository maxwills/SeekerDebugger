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

	^ 10
]

{ #category : #'as yet unclassified' }
TownEvent class >> numberOfActivities [

^ 10
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

	"Creates an activity with a randomized name, and with all the population as participants"

	^ TownEventActivity new
		  name: (TownEventActivity createRandomActivityName: random);
		  addParticipants: population;
		  yourself
]

{ #category : #'as yet unclassified' }
TownEvent >> deliverApples [

	population do: [ :villager | 
		| apples |
		apples := OrderedCollection new.
		1 to: self class applesPerParticipant do: [ :i | 
			| apple |
			apple := applesPool atRandom: random.
			applesPool remove: apple.
			apples add: apple.].
		villager receiveApples: apples ]
]

{ #category : #accessing }
TownEvent >> doClosureCeremony [

	"Each villager eat their basket of Apples"

	population do: [ :villager | villager eatAllApples ]
]

{ #category : #initialization }
TownEvent >> initialize [

	name := 'Unnamed town event'.
	population := self makePopulationContainer.
	activities := OrderedCollection new.
	random := self initializeRandom.
	applesPool := self makeApplesPoolContainer.
	"Hardcoded population of the town"
	population addAll: { 
			Villager newAlice.
			Villager newBob.
			Villager newCharlie }
]

{ #category : #initialization }
TownEvent >> initializeRandom [

	"We specify the seed to have a deterministic random"

	^ Random new
		  seed: 1;
		  yourself
]

{ #category : #'as yet unclassified' }
TownEvent >> logActivity: activity [

	TownEventLoggerUtil log: '******** Activity Log'.
	TownEventLoggerUtil log: 'Activity Started: ' , activity name.
	TownEventLoggerUtil log: 'Status: ' , self populationStatus asString
]

{ #category : #'as yet unclassified' }
TownEvent >> logClosureCeremony [

	TownEventLoggerUtil log: ''.
	TownEventLoggerUtil log: '***** Closure Ceremony *****'.
	TownEventLoggerUtil log: 'Closure ceremony started.'.
	TownEventLoggerUtil log: 'All apples were eaten'.
	TownEventLoggerUtil log: 'Status: ' , self populationStatus asString
]

{ #category : #'as yet unclassified' }
TownEvent >> logOpeningInformation [

	TownEventLoggerUtil clear.
	TownEventLoggerUtil log: '***** Event Opening *****'.
	TownEventLoggerUtil log: 'TownEvent Started.'.
	TownEventLoggerUtil log: 'Population: ' , self population asString.
	TownEventLoggerUtil log: 'Status: ' , self populationStatus asString.
	TownEventLoggerUtil log: 'Activities: ' , self activities size asString , ' registered activities.'.
	TownEventLoggerUtil log: ''
]

{ #category : #'as yet unclassified' }
TownEvent >> makeApplesPoolContainer [

	^ Set new
]

{ #category : #'as yet unclassified' }
TownEvent >> makePopulationContainer [

	^ Set new
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

	"Activities are created, Apples are created and delivered"

	| nActivities totalApples |
	totalApples := self class totalApples.
	nActivities := self class numberOfActivities.

	1 to: totalApples - 1 do: [ :i | 
		applesPool add: (Apple new
				 id: i;
				 yourself) ].
	applesPool add: (Apple new
			 id: totalApples;
			 healthy: false;
			 yourself).
	1 to: nActivities do: [ :i | activities add: self createActivity ].

	self deliverApples
]

{ #category : #accessing }
TownEvent >> population [

	^ population
]

{ #category : #accessing }
TownEvent >> population: anObject [

	population := anObject
]

{ #category : #'as yet unclassified' }
TownEvent >> populationStatus [

	^ population collect: [ :villager | villager name -> villager status ]
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
	"Performs every activity sequentially, and at the end, performs the closure ceremony"
	self logOpeningInformation.
	activities do: [ :activity | 
		activity start: random.
		self logActivity: activity ].
	self doClosureCeremony.
	self logClosureCeremony.
	
]
