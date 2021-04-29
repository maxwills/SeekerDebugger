Class {
	#name : #SeekerGlobals,
	#superclass : #Object,
	#instVars : [
		'seekerCodePresenterText',
		'auxiliaryTempStorage1',
		'auxiliaryTempStorage2'
	],
	#classVars : [
		'instance'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
SeekerGlobals class >> instance [
	instance ifNil: [ instance := self new ].
	^instance
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage1 [

	^ auxiliaryTempStorage1
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage1: anObject [

	auxiliaryTempStorage1 := anObject
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage2 [

	^ auxiliaryTempStorage2
]

{ #category : #accessing }
SeekerGlobals >> auxiliaryTempStorage2: anObject [

	auxiliaryTempStorage2 := anObject
]

{ #category : #accessing }
SeekerGlobals >> seekerCodePresenterText [

	^ seekerCodePresenterText
]

{ #category : #accessing }
SeekerGlobals >> seekerCodePresenterText: anObject [

	seekerCodePresenterText := anObject
]
