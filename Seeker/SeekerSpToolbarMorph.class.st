"
ToolbarMorph made for seeker.

Doesn't use tableLayout. This means that it doesn't interferefe with sizing issues (scroll bars of other widgets dissapearing when resizing the window to a certain lower size). Instead, the buttons are truncated.

It also makes the buttons to use less space without the initial vertical space.

This is not a final implementation.
"
Class {
	#name : #SeekerSpToolbarMorph,
	#superclass : #SpToolbarMorph,
	#instVars : [
		'marginBottom',
		'buttonSide'
	],
	#category : #'Seeker-UI'
}

{ #category : #adding }
SeekerSpToolbarMorph >> addItem: aToolbarItem position: aPosition [

	aPosition addItem: aToolbarItem into: self.
	self computeFullBounds.
	aToolbarItem
		height: buttonSide;
		bottom: self top + 30.
	"self refresh"
]

{ #category : #accessing }
SeekerSpToolbarMorph >> addItemLeft: aMorph [

	| lastSubMorphRight |
	lastSubMorphRight := 0.
	leftPanel submorphs ifNotEmpty: [ lastSubMorphRight := leftPanel submorphs last right].
	leftPanel addMorphBack: (aMorph
			 "vResizing: #rigid;"
			 left: lastSubMorphRight;
			 yourself)
	"aMorph top: 0.
	aMorph inspect."
]

{ #category : #initialization }
SeekerSpToolbarMorph >> initialize [

	"Dont call super"

	submorphs := EmptyArray.
	bounds := self defaultBounds.
	color := self defaultColor.
	buttonSide := 35.
	self initializePanels.
	self minHeight: buttonSide.	
	self leftPanel top: -5.
	self layoutPolicy: nil
]
