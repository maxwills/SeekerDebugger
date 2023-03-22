Class {
	#name : #SkWait,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SkWait class >> forMs: aNumber [

^ (Delay forMilliseconds: aNumber) wait
]
