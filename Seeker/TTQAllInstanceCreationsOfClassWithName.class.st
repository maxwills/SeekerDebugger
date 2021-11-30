Class {
	#name : #TTQAllInstanceCreationsOfClassWithName,
	#superclass : #TTQAllInstanceCreations,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllInstanceCreationsOfClassWithName class >> queryFrom: source withClassName: anObject [

	^ (self queryFrom: source)
		  newInstanceClassName: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllInstanceCreationsOfClassWithName class >> selectionFunction [

	^ SkSelectionInstanceCreationsOfClassNamed
]

{ #category : #accessing }
TTQAllInstanceCreationsOfClassWithName >> newInstanceClassName [

	^ selectionFunction newInstanceClassName
]

{ #category : #accessing }
TTQAllInstanceCreationsOfClassWithName >> newInstanceClassName: anObject [

	selectionFunction newInstanceClassName: anObject
]
