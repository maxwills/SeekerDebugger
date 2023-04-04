Class {
	#name : #SkSelectionFamixAssociationNodeAccesses,
	#superclass : #SkSelectionFamixAssociation,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionFamixAssociationNodeAccesses >> famixAssociationSlotsNames [

	^ famixAssociationSlotsNames ifNil: [ 
		  famixAssociationSlotsNames := (self slotsOfInterest collect: #name) asSet]
]
