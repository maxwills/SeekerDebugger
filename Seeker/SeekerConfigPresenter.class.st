Class {
	#name : #SeekerConfigPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'chkEnableMouseButtonEvent',
		'chkHandleMouseUp',
		'chkHandleMouseDown',
		'chkKeepMenusOpen',
		'btnReleaseMenus',
		'chkRestorationEnabled',
		'chkUseDeferredSetup',
		'btnResetEmergencyDeactivation',
		'chkIdentityEnforcingEnabled'
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
		  add: chkRestorationEnabled;
		  add: chkIdentityEnforcingEnabled;
		  add: chkUseDeferredSetup;
		  add: btnReleaseMenus;
		  add: btnResetEmergencyDeactivation;
		  yourself
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> handleReleasePinnedMenus [

	self config releasePinnedMenus
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> handleResetEmergencyDeactivation [

	SeekerSessionHelpers emergencyPreventLoading: false
]

{ #category : #api }
SeekerConfigPresenter >> initialExtent [

	^ 300 @ 300
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
	chkIdentityEnforcingEnabled := checkboxes add:
		                       (checkboxes add:
			                        (self createCheckbox: 'Identity enforcing enabled')).
	chkRestorationEnabled := checkboxes add:
		                         (self createCheckbox: 'Restoration enabled').
	chkUseDeferredSetup := checkboxes add:
		                       (self createCheckbox: 'Use deferred setup').
	btnReleaseMenus := self newButton
		                   label: 'Release pinned menus';
		                   action: [ self handleReleasePinnedMenus ];
		                   yourself.
	btnResetEmergencyDeactivation := self newButton
		                                 label: 'Reset emergency deactivation';
		                                 action: [ 
			                                 self handleResetEmergencyDeactivation ];
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
	chkIdentityEnforcingEnabled state: self config identityEnforcingEnabled.
	chkRestorationEnabled state: self config restorationEnabled.
	chkUseDeferredSetup state: self config deferredSetup
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateToConfig [

	self config enableMouseButtonEventDebug:
		chkEnableMouseButtonEvent state.
	self config handleMouseUpEvent: chkHandleMouseUp state.
	self config handleMouseDownEvent: chkHandleMouseDown state.
	self config keepMenusOpen: chkKeepMenusOpen state.
	self config restorationEnabled: chkRestorationEnabled state.
	self config identityEnforcingEnabled: chkIdentityEnforcingEnabled state.
	self config deferredSetup: chkUseDeferredSetup state
]
