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
		'chkIdentityEnforcingEnabled',
		'chkSeekerEnabled',
		'chkQuickWrapEnabled',
		'chkIncludeTestsSetup',
		'chkObjectTrackingEnabled',
		'chkQueryResultsLimitEnabled'
	],
	#category : #'Seeker-UI'
}

{ #category : #'instance creation' }
SeekerConfigPresenter class >> open [

	<script>
	| presenter app |
	presenter := SeekerConfigPresenter new.
	presenter application: (app := SpApplication new).
	^ presenter open title: 'SeekerDebugger Configuration'
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
		  add: chkObjectTrackingEnabled;
		  add: chkRestorationEnabled;
		  add: chkIdentityEnforcingEnabled;
		  add: chkQueryResultsLimitEnabled;
		  add: chkIncludeTestsSetup;
		  add: chkUseDeferredSetup;
		  add: chkSeekerEnabled;
		  add: chkQuickWrapEnabled;
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

	^ 300 @ 400
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
	chkObjectTrackingEnabled := checkboxes add:
		                            (self createCheckbox:
			                             'Object tracking enabled').
	chkIdentityEnforcingEnabled := checkboxes add:
		                               (checkboxes add:
			                                (self createCheckbox:
				                                 'Identity enforcing enabled')).
	chkRestorationEnabled := checkboxes add:
		                         (self createCheckbox: 'Restoration enabled').
	chkUseDeferredSetup := checkboxes add:
		                       (self createCheckbox: 'Use deferred setup').
	chkSeekerEnabled := checkboxes add:
		                    (self createCheckbox: 'SeekerDebugger enabled').
	chkQuickWrapEnabled := checkboxes add:
		                       (self createCheckbox: 'QuickWrap enabled').

	chkIncludeTestsSetup := checkboxes add:
		                        (self createCheckbox: 'Include tests setup').
	chkQueryResultsLimitEnabled := checkboxes add:
		                               (self createCheckbox:
			                                'Query results limit enabled').
	btnReleaseMenus := self newButton
		                   label: 'Release pinned menus';
		                   action: [ self handleReleasePinnedMenus ];
		                   yourself.
	btnResetEmergencyDeactivation := self newButton
		                                 label:
			                                 'Reset emergency deactivation';
		                                 action: [ 
			                                 self
				                                 handleResetEmergencyDeactivation ];
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
	chkIdentityEnforcingEnabled state:
		self config identityEnforcingEnabled.
	chkObjectTrackingEnabled state: self config objectTrackingEnabled.
	chkRestorationEnabled state: self config restorationEnabled.
	chkUseDeferredSetup state: self config deferredSetup.
	chkSeekerEnabled state: self config seekerEnabled.
	chkQuickWrapEnabled state: self config quickWrapEnabled.
	chkIncludeTestsSetup state: self config includeTestsSetup.
	chkQueryResultsLimitEnabled state:
		self config queryResultsLimitEnabled
]

{ #category : #'as yet unclassified' }
SeekerConfigPresenter >> updateToConfig [

	self config enableMouseButtonEventDebug:
		chkEnableMouseButtonEvent state.
	self config handleMouseUpEvent: chkHandleMouseUp state.
	self config handleMouseDownEvent: chkHandleMouseDown state.
	self config keepMenusOpen: chkKeepMenusOpen state.
	self config restorationEnabled: chkRestorationEnabled state.
	self config identityEnforcingEnabled:
		chkIdentityEnforcingEnabled state.
	self config deferredSetup: chkUseDeferredSetup state.

	self config objectTrackingEnabled: chkObjectTrackingEnabled state.
	self config seekerEnabled: chkSeekerEnabled state.
	self config quickWrapEnabled: chkQuickWrapEnabled state.
	self config includeTestsSetup: chkIncludeTestsSetup state.
	self config queryResultsLimitEnabled:
		chkQueryResultsLimitEnabled state
]
