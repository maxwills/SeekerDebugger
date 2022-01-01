Class {
	#name : #SeekerConfigPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'chkEnableMouseButtonEvent',
		'chkHandleMouseUp',
		'chkHandleMouseDown'
	],
	#category : #'Seeker-UI'
}

{ #category : #'instance creation' }
SeekerConfigPresenter class >> open [

	<script>
	| presenter app |
	presenter := SeekerConfigPresenter new.
	presenter application: (app := SpApplication new).
	^ presenter openWithSpec title: 'SeekerDebugger Configuration'
]

{ #category : #accessing }
SeekerConfigPresenter >> chkEnableMouseButtonEvent [

	^ chkEnableMouseButtonEvent
]

{ #category : #accessing }
SeekerConfigPresenter >> chkEnableMouseButtonEvent: anObject [

	chkEnableMouseButtonEvent := anObject
]

{ #category : #accessing }
SeekerConfigPresenter >> chkHandleMouseDown [

	^ chkHandleMouseDown
]

{ #category : #accessing }
SeekerConfigPresenter >> chkHandleMouseDown: anObject [

	chkHandleMouseDown := anObject
]

{ #category : #accessing }
SeekerConfigPresenter >> chkHandleMouseUp [

	^ chkHandleMouseUp
]

{ #category : #accessing }
SeekerConfigPresenter >> chkHandleMouseUp: anObject [

	chkHandleMouseUp := anObject
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> createChecksLayout [

	^ SpBoxLayout newTopToBottom
		  add: chkEnableMouseButtonEvent;
		  add: chkHandleMouseUp;
		  add: chkHandleMouseDown;
		  yourself
]

{ #category : #api }
SeekerConfigPresenter >> initialExtent [

	^ 350 @ 100
]

{ #category : #initialization }
SeekerConfigPresenter >> initializePresenters [

	super initializePresenters.
	chkEnableMouseButtonEvent := self newCheckBox
		                             label: 'Enable MouseButtonEvent Debug';
		                             yourself.
	chkHandleMouseUp := self newCheckBox
		                    label: 'Handle MouseUp events';
		                    yourself.
	chkHandleMouseDown := self newCheckBox
		                      label: 'Handle MouseDown events';
		                      yourself.
	"self window title: 'Seeker Debugger Configuration'."
	self updateFromConfig.
	chkEnableMouseButtonEvent whenChangedDo: [ self updateToConfig ].
	chkHandleMouseUp whenChangedDo: [ self updateToConfig ].
	chkHandleMouseDown whenChangedDo: [ self updateToConfig ].
	self layout: (SpBoxLayout newLeftToRight
			 add: self createChecksLayout;
			 "		add: #checkboxExample;"yourself)
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateFromConfig [

	chkEnableMouseButtonEvent state:
		SeekerConfig default enableMouseButtonEventDebug.
	chkHandleMouseUp state: SeekerConfig default handleMouseUpEvent.
	chkHandleMouseDown state: SeekerConfig default handleMouseDownEvent
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateToConfig [

	SeekerConfig default enableMouseButtonEventDebug:
		chkEnableMouseButtonEvent state
]
