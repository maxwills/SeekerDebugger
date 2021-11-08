Class {
	#name : #SeekerMessageDialog,
	#superclass : #MessageDialogWindow,
	#instVars : [
		'entryText'
	],
	#category : #'Seeker-UI'
}

{ #category : #'as yet unclassified' }
SeekerMessageDialog class >> showDialog: text withTitle: title [

	| dialog width linesCount |
	width := 0.
	linesCount := 0.
	text linesDo: [ :l | 
		linesCount := linesCount + 1.
		width := width max:
			         (UIManager default theme textFont widthOfStringOrText: l) ].
	dialog := self new text: text.
	dialog title: title.
	dialog open.
	dialog height: 55 * linesCount.
	dialog textMorph
		minWidth: 20;
		minHeight: 1.
	dialog width: (width + 120 min: Display width - 50)
	"dialog position: 25 @ 25"
]

{ #category : #'as yet unclassified' }
SeekerMessageDialog class >> showModalDialog: text withTitle: title [

	(StPharoApplication current newInform
		 label: text;
		 title: title;
		 yourself) openModalWithSpec
]

{ #category : #accessing }
SeekerMessageDialog >> entryText [
	"Answer the value of entryText"

	^ entryText
]

{ #category : #accessing }
SeekerMessageDialog >> entryText: anObject [
	"Set the value of entryText"

	entryText := anObject.
	self changed: #entryText
]

{ #category : #testing }
SeekerMessageDialog >> isResizeable [
	"Answer whether we are not we can be resized."

	^true
]

{ #category : #building }
SeekerMessageDialog >> newContentMorph [
	"Answer a new content morph."

	self iconMorph: self newIconMorph.
	self textMorph: self newTextMorph.
	^self newGroupboxFor: (
		(self newRow: {self iconMorph. self textMorph})
			cellPositioning: #top;
			vResizing: #spaceFill)
]

{ #category : #building }
SeekerMessageDialog >> newTextMorph [
	"Answer a new text editor morph."

	|tm|
	tm := (self
		newTextEditorFor: self
		getText: #entryText
		setText: #entryText:
		getEnabled: nil)
			beForPlainText;
			minWidth: 20;
			minHeight: 20;
			beReadOnly.
	^tm
]

{ #category : #accessing }
SeekerMessageDialog >> text: aStringOrText [
	"Set the text."
	
	|t|
	t := aStringOrText isString
		ifTrue: [aStringOrText asText addAttribute: (TextFontReference toFont: self textFont); yourself]
		ifFalse: [aStringOrText].
	self entryText: t
]
