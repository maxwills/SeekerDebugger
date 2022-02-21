Class {
	#name : #SeekerSpToolbarMorph,
	#superclass : #SpToolbarMorph,
	#instVars : [
		'marginBottom'
	],
	#category : #'Seeker-UI'
}

{ #category : #adding }
SeekerSpToolbarMorph >> addItem: aToolbarItem position: aPosition [

	aPosition addItem: aToolbarItem into: self.
	self computeFullBounds.
	self minHeight: aToolbarItem extent y + marginBottom.

	self refresh
]

{ #category : #initialization }
SeekerSpToolbarMorph >> initialize [

	super initialize.
	self flag:
		'uninitializing default toolbar layout. Why? because having a layout makes the widget to reserve space.'.
	marginBottom := 15.
	self layoutPolicy: nil.
	self
		listDirection: #rightToLeft;
		hResizing: #rigid;
		vResizing: #shrinkWrap;
		wrapCentering: #left;
		color: self defaultColor;
		extent: 0 @ 0.

	self layoutChanged
]
