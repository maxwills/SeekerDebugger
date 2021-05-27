Class {
	#name : #SkContextCacheObject,
	#superclass : #SeekerCacheObject,
	#instVars : [
		'contextBcp'
	],
	#category : #'Seeker-SeekerCache'
}

{ #category : #initialization }
SkContextCacheObject >> initialize [

	super initialize
]

{ #category : #accessing }
SkContextCacheObject >> tracedContextPC [

	^ contextBcp ifNil: [ 
		  | context |
		  context := self source.
		  context sender ifNil: [ ^ SkTracedContextPC new ].
		  contextBcp := context sender tracedContextPC / context sender executedPC.
		  contextBcp ]
]
