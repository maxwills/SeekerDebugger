Class {
	#name : #ScopedTranscriptLogger,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #initialization }
ScopedTranscriptLogger >> finalize [

	Transcript show: 'finalize' , String cr
]

{ #category : #initialization }
ScopedTranscriptLogger >> initialize [

	Transcript show: 'initialed' , String cr
]
