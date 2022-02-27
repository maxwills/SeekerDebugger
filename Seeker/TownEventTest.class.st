Class {
	#name : #TownEventTest,
	#superclass : #TestCase,
	#category : #'Seeker-Presentation'
}

{ #category : #tests }
TownEventTest >> testEvent [

	| t |
	t := TownEventTrueRandom new.
	t organizeEvent.
	t start.

	t population do: [ :villager | self deny: villager status equals: #kia ]
]
