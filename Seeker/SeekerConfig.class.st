Class {
	#name : #SeekerConfig,
	#superclass : #Object,
	#instVars : [
		'enableMouseButtonEventDebug',
		'handleMouseUpEvent',
		'handleMouseDownEvent',
		'keepMenusOpen',
		'restorationEnabled',
		'autoInstrumentationStepping',
		'deferredSetup',
		'indentityEnforcingEnabled',
		'seekerEnabled',
		'quickWrapEnabled',
		'objectTrackingEnabled',
		'queryResultsLimitEnabled',
		'queryResultsLimit',
		'includeTestsSetup'
	],
	#classVars : [
		'DefaultInstance'
	],
	#category : #'Seeker-Helpers'
}

{ #category : #accessing }
SeekerConfig class >> default [

	^ DefaultInstance
]

{ #category : #initialization }
SeekerConfig class >> initialize [

	DefaultInstance := self new
]

{ #category : #accessing }
SeekerConfig >> autoInstrumentationStepping [

	^ autoInstrumentationStepping
]

{ #category : #accessing }
SeekerConfig >> autoInstrumentationStepping: anObject [

	autoInstrumentationStepping := anObject
]

{ #category : #accessing }
SeekerConfig >> deferredSetup [

	^ deferredSetup
]

{ #category : #accessing }
SeekerConfig >> deferredSetup: anObject [

	deferredSetup := anObject
]

{ #category : #accessing }
SeekerConfig >> enableMouseButtonEventDebug [

	^ enableMouseButtonEventDebug
]

{ #category : #accessing }
SeekerConfig >> enableMouseButtonEventDebug: anObject [

	enableMouseButtonEventDebug := anObject
]

{ #category : #accessing }
SeekerConfig >> handleMouseDownEvent [

	^ handleMouseDownEvent
]

{ #category : #accessing }
SeekerConfig >> handleMouseDownEvent: anObject [

	handleMouseDownEvent := anObject
]

{ #category : #accessing }
SeekerConfig >> handleMouseUpEvent [

	^ handleMouseUpEvent
]

{ #category : #accessing }
SeekerConfig >> handleMouseUpEvent: anObject [

	handleMouseUpEvent := anObject
]

{ #category : #accessing }
SeekerConfig >> identityEnforcingEnabled [

	^ indentityEnforcingEnabled
]

{ #category : #accessing }
SeekerConfig >> identityEnforcingEnabled: anObject [

	indentityEnforcingEnabled := anObject
]

{ #category : #accessing }
SeekerConfig >> includeTestsSetup [

	^ includeTestsSetup
]

{ #category : #accessing }
SeekerConfig >> includeTestsSetup: anObject [

	includeTestsSetup := anObject
]

{ #category : #initialization }
SeekerConfig >> initialize [

	enableMouseButtonEventDebug := false.
	handleMouseUpEvent := false.
	handleMouseDownEvent := false.
	keepMenusOpen := false.
	restorationEnabled := true.
	indentityEnforcingEnabled := true.
	autoInstrumentationStepping := false.
	deferredSetup := false.
	seekerEnabled := true.
	quickWrapEnabled := true.
	objectTrackingEnabled := true.
	queryResultsLimitEnabled := false.
	queryResultsLimit := 10000.
	includeTestsSetup := false
]

{ #category : #accessing }
SeekerConfig >> keepMenusOpen [

	^ keepMenusOpen
]

{ #category : #accessing }
SeekerConfig >> keepMenusOpen: anObject [

	keepMenusOpen := anObject
]

{ #category : #accessing }
SeekerConfig >> objectTrackingEnabled [

	^ objectTrackingEnabled
]

{ #category : #accessing }
SeekerConfig >> objectTrackingEnabled: anObject [

	objectTrackingEnabled := anObject
]

{ #category : #accessing }
SeekerConfig >> queryResultsLimit [

	^ queryResultsLimit
]

{ #category : #accessing }
SeekerConfig >> queryResultsLimit: anObject [

	queryResultsLimit := anObject
]

{ #category : #accessing }
SeekerConfig >> queryResultsLimitEnabled [

	^ queryResultsLimitEnabled
]

{ #category : #accessing }
SeekerConfig >> queryResultsLimitEnabled: anObject [

	queryResultsLimitEnabled := anObject
]

{ #category : #accessing }
SeekerConfig >> quickWrapEnabled [

	^ quickWrapEnabled
]

{ #category : #accessing }
SeekerConfig >> quickWrapEnabled: anObject [

	| wasEnabled |
	wasEnabled := quickWrapEnabled.
	quickWrapEnabled := anObject.
	wasEnabled = quickWrapEnabled ifTrue: [ ^ self ].
	QuickWrap uninstallQuickWrapSystem.
	quickWrapEnabled ifFalse: [ ^ self ].
	QuickWrap installQuickWrapSystem.
	QuickWrap refreshAllWrappers
]

{ #category : #'as yet unclassified' }
SeekerConfig >> releasePinnedMenus [

	SeekerSessionHelpers releasePinnedMenus
]

{ #category : #accessing }
SeekerConfig >> restorationEnabled [

	^ restorationEnabled
]

{ #category : #accessing }
SeekerConfig >> restorationEnabled: anObject [

	restorationEnabled := anObject
]

{ #category : #accessing }
SeekerConfig >> seekerEnabled [

	^ seekerEnabled
]

{ #category : #accessing }
SeekerConfig >> seekerEnabled: anObject [

	| wasEnabled |
	wasEnabled := seekerEnabled.
	seekerEnabled := anObject.
	wasEnabled = seekerEnabled ifTrue: [ ^ self ].
	SeekerInstallHelpers uninstall.
	seekerEnabled ifTrue: [ SeekerInstallHelpers install ]
]
