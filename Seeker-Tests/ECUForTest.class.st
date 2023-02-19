Class {
	#name : #ECUForTest,
	#superclass : #SeekerExecutor,
	#instVars : [
		'steppingTCUIndex'
	],
	#category : #'Seeker-Tests-ECU'
}

{ #category : #'as yet unclassified' }
ECUForTest >> chooseNextTCUIndex [
	"If the tcu index is set, step that tcu. If not, use the super choosing strategy"

	steppingTCUIndex ifNil: [ ^ super chooseNextTCUIndex ].
	^ steppingTCUIndex
]

{ #category : #accessing }
ECUForTest >> steppingTCUIndex [

	^ steppingTCUIndex
]

{ #category : #accessing }
ECUForTest >> steppingTCUIndex: anObject [

	steppingTCUIndex := anObject
]
