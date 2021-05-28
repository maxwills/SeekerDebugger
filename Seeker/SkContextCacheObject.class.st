Class {
	#name : #SkContextCacheObject,
	#superclass : #SeekerCacheObject,
	#instVars : [
		'stackDepth',
		'tracedContextPC'
	],
	#category : #'Seeker-SeekerCache'
}

{ #category : #initialization }
SkContextCacheObject >> initialize [

	super initialize
]

{ #category : #accessing }
SkContextCacheObject >> stackDepth [

	^ stackDepth ifNil: [ 
		  | sender |
		  sender := self source sender.
		  sender
			  ifNil: [ stackDepth := 1 ]
			  ifNotNil: [ stackDepth := 1 "sender stackDepth + " ] ]
]

{ #category : #accessing }
SkContextCacheObject >> tracedContextPC [

	^ tracedContextPC ifNil: [ 
		  | context |
		  context := self source.
		  context sender ifNil: [ ^ SkTracedContextPC new ].
		  tracedContextPC := context sender tracedContextPC / context sender executedPC.
		  tracedContextPC ]
]
