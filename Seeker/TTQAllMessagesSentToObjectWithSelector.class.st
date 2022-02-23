Class {
	#name : #TTQAllMessagesSentToObjectWithSelector,
	#superclass : #TTQAllMessageSends,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllMessagesSentToObjectWithSelector class >> performWith: tracer withArg: arg [

	self error: 'dont use this'
]

{ #category : #'as yet unclassified' }
TTQAllMessagesSentToObjectWithSelector class >> queryFrom: source withObjectOid: aNumber andMessageSelector: messageSelector [

	^ (self queryFrom: source)
		  objectOid: aNumber;
		  messageSelector: messageSelector;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllMessagesSentToObjectWithSelector class >> selectionFunction [

	^ SkSelectionMessagesSentToObjectWithSelector
]

{ #category : #accessing }
TTQAllMessagesSentToObjectWithSelector >> messageSelector [

	^ selectionFunction messageSelector
]

{ #category : #accessing }
TTQAllMessagesSentToObjectWithSelector >> messageSelector: anObject [

	selectionFunction messageSelector: anObject
]

{ #category : #accessing }
TTQAllMessagesSentToObjectWithSelector >> objectOid [

	^ selectionFunction messageReceiverOid
]

{ #category : #accessing }
TTQAllMessagesSentToObjectWithSelector >> objectOid: anObject [

	selectionFunction messageReceiverOid: anObject
]
