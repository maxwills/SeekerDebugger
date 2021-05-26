Class {
	#name : #SkExtContext,
	#superclass : #ObjectExtension,
	#instVars : [
		'contextBcp'
	],
	#category : #'Seeker-ObjectExtensions'
}

{ #category : #accessing }
SkExtContext >> bcp [

	^ contextBcp ifNil: [ 
		  | context |
		  context := self source.
		  context sender ifNil: [ ^ SkContextBCPath new ].
		  contextBcp := context sender bcp / context sender executedPC.
		  contextBcp ]
]

{ #category : #initialization }
SkExtContext >> initialize [

	super initialize
]
