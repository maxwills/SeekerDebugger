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
	"self computeFullBounds."
	aToolbarItem
		height: buttonSide;
		bottom: self top + 30.
	self refresh
]

{ #category : #accessing }
SeekerSpToolbarMorph >> addItemLeft: aMorph [

	| lastSubMorphRight |
	lastSubMorphRight := 0.
	leftPanel submorphs ifNotEmpty: [ lastSubMorphRight := leftPanel submorphs last right].
	leftPanel addMorphBack: (aMorph
			 vResizing: #rigid;
			 left: lastSubMorphRight;
			 yourself)
	"aMorph top: 0.
	aMorph inspect."
]

{ #category : #initialization }
SeekerSpToolbarMorph >> initialize [

	super initialize.
	buttonSide := 35.
	"	self clipSubmorphs: true."
	self flag:
		'uninitializing default toolbar layout. Why? because having a layout makes the widget to reserve space.'.
	self minHeight: buttonSide.
	self layoutPolicy: nil.
	self
		listDirection: #rightToLeft;
		hResizing: #shrinkWrap;
		vResizing: #rigid;
		color: self defaultColor;
		extent: 0 @ 0.
	"	self leftPanel top: self top - 30.
	self rightPanel top: self top - 30."
	self leftPanel height: buttonSide.
	self rightPanel height: buttonSide.
	self leftPanel layoutPolicy: nil.
	self leftPanel vResizing: #rigid.
	self rightPanel vResizing: #rigid.
	self rightPanel layoutPolicy: nil.
	self leftPanel top: -5.
	self layoutChanged
]
