Class {
	#name : #TownEventTrueRandom,
	#superclass : #TownEvent,
	#category : #'Seeker-Presentation'
}

{ #category : #initialization }
TownEventTrueRandom >> initializeRandom [

	^ Random new
]

{ #category : #'as yet unclassified' }
TownEventTrueRandom >> makeApplesPoolContainer [

	^ IdentitySet new
]

{ #category : #'as yet unclassified' }
TownEventTrueRandom >> makePopulationContainer [

	^ IdentitySet new
]
