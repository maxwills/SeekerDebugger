Class {
	#name : #SeekerConfigPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'chkEnableMouseButtonEvent',
		'chkHandleMouseUp',
		'chkHandleMouseDown',
		'btnReleaseMenus'
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
SeekerConfigPresenter >> config [

	^ SeekerConfig default
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> createChecksLayout [

	^ SpBoxLayout newTopToBottom
		  add: chkEnableMouseButtonEvent;
		  add: chkHandleMouseUp;
		  add: chkHandleMouseDown;
		  add: btnReleaseMenus;
		  yourself
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> handleReleasePinnedMenus [

	self config releasePinnedMenus
]

{ #category : #api }
SeekerConfigPresenter >> initialExtent [

	^ 350 @ 140
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
	btnReleaseMenus := self newButton
		                   label: 'Release Pinned Menus';
		                   action: [ self handleReleasePinnedMenus ];
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
			self config enableMouseButtonEventDebug.
	chkHandleMouseUp state: 	self config handleMouseUpEvent.
	chkHandleMouseDown state: 	self config handleMouseDownEvent
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateToConfig [

	self config enableMouseButtonEventDebug:
		chkEnableMouseButtonEvent state.
	self config handleMouseUpEvent: chkHandleMouseUp state.
	self config handleMouseDownEvent: chkHandleMouseDown state
]
