Class {
	#name : #SkSelectionFamixAssociationNavigation,
	#superclass : #SkSelectionFamixAssociation,
	#category : #'Seeker-DTTQ-Moose-Functions-Selection'
}

{ #category : #accessing }
SkSelectionFamixAssociationNavigation >> famixAssociationSlotsNames [

	^ famixAssociationSlotsNames ifNil: [ 
		  famixAssociationSlotsNames := (self slotsOfInterest collect: #inverseName) asSet ]
]
