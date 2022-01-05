Class {
	#name : #SeekerConfigPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'chkEnableMouseButtonEvent',
		'chkHandleMouseUp',
		'chkHandleMouseDown',
		'chkKeepMenusOpen',
		'btnReleaseMenus',
		'chkRecordingEnabled',
		'chkRestorationEnabled'
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
SeekerConfigPresenter >> createCheckbox: label [

	^ self newCheckBox
		  label: label;
		  yourself
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> createChecksLayout [

	^ SpBoxLayout newTopToBottom
		  add: chkEnableMouseButtonEvent;
		  add: chkHandleMouseUp;
		  add: chkHandleMouseDown;
		  add: chkKeepMenusOpen;
		  add: chkRecordingEnabled;
		  add: chkRestorationEnabled;
		  add: btnReleaseMenus;
		  yourself
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> handleReleasePinnedMenus [

	self config releasePinnedMenus
]

{ #category : #api }
SeekerConfigPresenter >> initialExtent [

	^ 350 @ 200
]

{ #category : #initialization }
SeekerConfigPresenter >> initializePresenters [

	| checkboxes |
	checkboxes := OrderedCollection new.
	super initializePresenters.
	chkEnableMouseButtonEvent := self createCheckbox:
		                             'Enable MouseButtonEvent debug'.

	chkHandleMouseUp := checkboxes add:
		                    (self createCheckbox: 'Handle MouseUp events').
	chkHandleMouseDown := checkboxes add:
		                      (self createCheckbox:
			                       'Handle MouseDown events').
	chkKeepMenusOpen := checkboxes add:
		                    (self createCheckbox: 'Keep menus open').
	chkRecordingEnabled := checkboxes add:
		                       (checkboxes add:
			                        (self createCheckbox: 'Recording enabled')).
	chkRestorationEnabled := checkboxes add:
		                         (self createCheckbox: 'Restoration enabled').
	btnReleaseMenus := self newButton
		                   label: 'Release pinned menus';
		                   action: [ self handleReleasePinnedMenus ];
		                   yourself.

	"self window title: 'Seeker Debugger Configuration'."
	self updateFromConfig.
	checkboxes do: [ :each | each whenChangedDo: [ self updateToConfig ] ].
	self layout: (SpBoxLayout newLeftToRight
			 add: self createChecksLayout;
			 "		add: #checkboxExample;"yourself)
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateFromConfig [

	chkEnableMouseButtonEvent state:
		self config enableMouseButtonEventDebug.
	chkHandleMouseUp state: self config handleMouseUpEvent.
	chkHandleMouseDown state: self config handleMouseDownEvent.
	chkKeepMenusOpen state: self config keepMenusOpen.
	chkRecordingEnabled state: self config recordingEnabled.
	chkRestorationEnabled state: self config restorationEnabled
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateToConfig [

	self config enableMouseButtonEventDebug:
		chkEnableMouseButtonEvent state.
	self config handleMouseUpEvent: chkHandleMouseUp state.
	self config handleMouseDownEvent: chkHandleMouseDown state.
	self config keepMenusOpen: chkKeepMenusOpen state.
	self config restorationEnabled: chkKeepMenusOpen state.
	self config recordingEnabled: chkKeepMenusOpen state
]
