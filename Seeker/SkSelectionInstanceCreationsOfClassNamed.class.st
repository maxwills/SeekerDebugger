Class {
	#name : #SkSelectionInstanceCreationsOfClassNamed,
	#superclass : #SkSelectionInstanceCreations,
	#instVars : [
		'newInstanceClassName'
	],
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #accessing }
SkSelectionInstanceCreationsOfClassNamed >> newInstanceClassName [

	^ newInstanceClassName
]

{ #category : #accessing }
SkSelectionInstanceCreationsOfClassNamed >> newInstanceClassName: anObject [

	newInstanceClassName := anObject
]

{ #category : #accessing }
SkSelectionInstanceCreationsOfClassNamed >> value: state [

	^ state isInstantiationMessage and: [ 
		  state classNameOfObjectAboutToBeInstantiated
		  == newInstanceClassName ]
]
