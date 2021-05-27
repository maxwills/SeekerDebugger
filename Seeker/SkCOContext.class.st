Class {
	#name : #SkCOContext,
	#superclass : #SeekerCacheObject,
	#instVars : [
		'contextBcp'
	],
	#category : #'Seeker-SeekerCache'
}

{ #category : #initialization }
SkCOContext >> initialize [

	super initialize
]

{ #category : #accessing }
SkCOContext >> tracedContextPC [

	^ contextBcp ifNil: [ 
		  | context |
		  context := self source.
		  context sender ifNil: [ ^ SkTracedContextPC new ].
		  contextBcp := context sender tracedContextPC / context sender executedPC.
		  contextBcp ]
]
