Class {
	#name : #SeekerSpFTTableMorph,
	#superclass : #SpFTTableMorph,
	#instVars : [
		'minWidth'
	],
	#category : #'Seeker-UI'
}

{ #category : #initialization }
SeekerSpFTTableMorph >> initialize [

	minWidth := 200.
	horizontalScrollBar := true.
	super initialize
]

{ #category : #accessing }
SeekerSpFTTableMorph >> minWidth [

	"answer the receiver's minHeight"

	^ minWidth
]
