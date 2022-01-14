Class {
	#name : #SeekerMetaDebugHelper,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #'as yet unclassified' }
SeekerMetaDebugHelper class >> doBlock: aBlock [

	"used to quickly return. equivalent to true ifTrue: [^self], but I can track by references to this class"

	aBlock value
]
