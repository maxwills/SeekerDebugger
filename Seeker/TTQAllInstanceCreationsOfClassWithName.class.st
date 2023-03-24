Class {
	#name : #TTQAllInstanceCreationsOfClassWithName,
	#superclass : #TTQAllInstanceCreations,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
TTQAllInstanceCreationsOfClassWithName class >> performWith: tracer withArg: arg [

	tracer ui showInResult:
		(self queryFrom: tracer newProgramStates withClassName: arg) displayModel 
]

{ #category : #'as yet unclassified' }
TTQAllInstanceCreationsOfClassWithName class >> queryFrom: source withClassName: anObject [

	^ (self queryFrom: source)
		  newInstanceClassName: anObject;
		  yourself
]

{ #category : #'as yet unclassified' }
TTQAllInstanceCreationsOfClassWithName class >> queryInteractivelyFrom: source [ 

	^ (self queryFrom: source)
		  newInstanceClassName: SkInteractivelyQueryFromHelper requestClassName;
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
