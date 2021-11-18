Class {
	#name : #SeekerUIHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerUIHelpers class >> safeInvoke: aBlock [

	UIManager default uiProcess == Processor activeProcess
		ifTrue: [ aBlock value ]
		ifFalse: [ UIManager default defer: aBlock ]
]
