Class {
	#name : #SkComponent,
	#superclass : #Object,
	#instVars : [
		'componentsHolder'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #'instance creation' }
SkComponent class >> newFor: anObject [

	^ self new
		  componentsHolder: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
SkComponent >> bindComponents [

	"subclasses must reimplement this method"

	
]

{ #category : #accessing }
SkComponent >> componentsHolder [

	^ componentsHolder
]

{ #category : #accessing }
SkComponent >> componentsHolder: anObject [

	componentsHolder := anObject
]
