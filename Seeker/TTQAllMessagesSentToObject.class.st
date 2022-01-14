Class {
	#name : #TTQAllMessagesSentToObject,
	#superclass : #TTQAllMessageSends,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllMessagesSentToObject class >> performWith: tracer withArg: arg [

	tracer ui showInResult:
		(self queryFrom: tracer newProgramStates withObjectOid: arg) displayModel 
]

{ #category : #'as yet unclassified' }
TTQAllMessagesSentToObject class >> queryFrom: source withObjectOid: aNumber [

	^ (self queryFrom: source)
		  objectOid: aNumber;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllMessagesSentToObject class >> selectionFunction [

	^ SkSelectionMessagesSentToObject
]

{ #category : #accessing }
TTQAllMessagesSentToObject >> objectOid [

	^ selectionFunction messageReceiverOid
]

{ #category : #accessing }
TTQAllMessagesSentToObject >> objectOid: anObject [

	selectionFunction messageReceiverOid: anObject
]
