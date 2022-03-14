Class {
	#name : #StInspectorSeekerQueriesCommand,
	#superclass : #StInspectorCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
StInspectorSeekerQueriesCommand class >> defaultDescription [

	^ 'Show menu with Seeker Queries'
]

{ #category : #initialization }
StInspectorSeekerQueriesCommand class >> defaultIconName [

	^ #exception
]

{ #category : #default }
StInspectorSeekerQueriesCommand class >> defaultName [
	<toolbarInspectCommand: 10>

	^ 'SeekerQueries'
]

{ #category : #documentation }
StInspectorSeekerQueriesCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors
]

{ #category : #execution }
StInspectorSeekerQueriesCommand >> execute [

	"Shows a menu with all Seeker Object centric queries and actions related to the inspected object"

	| menu object |
	object := self model inspectedObject.
	menu := MenuMorph new.

	self privAddTimeTravelToInstantiationMenuEntry: menu.

	menu add: 'List all messages sent to the inspected object'
		target: self
		selector: #seekAllMessages:
		argument: object.
	menu add: 'Specific message...' subMenu: (self privMakeSelectorsMenu: object).
	menu add: 'List all assignment to the instance variables of the inspected object'
		target: self
		selector: #seekAllChanges:
		argument: object.
	menu add: 'Specific instance variable...' subMenu: (self privMakeVariablesMenu: object).
	self privAddFindAllReadingsMenuEntry: menu.
	menu invokeModal
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> findAllReadingsOfObjectWithOid: aNumber in: seeker [

	(UTTQAllReadingsOfObject queryFrom: seeker newProgramStates forOid: aNumber) showInSeeker
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privAddFindAllReadingsMenuEntry: menu [

	| seekerAndOidPair stInspector "SeekerAndOidPair" |
	stInspector := self context findOwner: [ :pres | pres class = StInspector ].
	stInspector ifNil: [ ^ self ].
	seekerAndOidPair := SeekerInspectorSynchronizer default getSeekerAndOidForInspector: stInspector.

	seekerAndOidPair ifNil: [ ^ self ].
	menu add: 'Find all readings of self'
		target: self
		selector: #findAllReadingsOfObjectWithOid:in:
		argumentList: { 
				seekerAndOidPair oid.
				seekerAndOidPair seeker }
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privAddTimeTravelToInstantiationMenuEntry: menu [

	| seekerAndOidPair stInspector "SeekerAndOidPair" |
	stInspector := self context findOwner: [ :pres | pres class = StInspector ].
	stInspector ifNil: [ ^ self ].
	seekerAndOidPair := SeekerInspectorSynchronizer default getSeekerAndOidForInspector: stInspector.

	seekerAndOidPair ifNil: [ ^ self ].
	menu add: 'Time-Travel to instantiation instruction'
		target: seekerAndOidPair seeker
		selector: #timeTravelToBytecodeIndex:
		argument: seekerAndOidPair oid
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privFindInstanceVariables: object [

	object ifNil: [ ^ #(  ) ].
	
	^ object class allInstVarNames sorted
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privFindSelectors: object [

	object ifNil: [ ^ #(  ) ].
	
	^ object class allSelectors sorted
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privFindSelectorsOfClass: cls [

	cls = UndefinedObject ifTrue: [ ^ #(  ) ].
	
	^ cls selectors sorted
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privMakeSelectorsMenu: object [

	| menu superClasses |
	menu := MenuMorph new.
	superClasses := OrderedCollection new.
	superClasses add: object class.
	object class allSuperclassesDo: [ :sc | superClasses add: sc ].

	superClasses do: [ :cls | 
		menu add: cls name subMenu: (self privMakeSelectorsMenuForClass: cls ofObject: object) ].
	^ menu
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privMakeSelectorsMenuForClass: cls ofObject: object [

	| menu selNames |
	menu := MenuMorph new.
	selNames := self privFindSelectorsOfClass: cls.
	selNames do: [ :selector | 
		menu add: selector asString
			target: self
			selector: #seekAllMessagesOn:ofSelector:
			argumentList: { 
					object.
					selector } ].
	^ menu
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> privMakeVariablesMenu: object [

	| menu varNames |
	menu := MenuMorph new.
	varNames := self privFindInstanceVariables: object.
	varNames do: [ :varName | 
		menu add: varName asString
			target: self
			selector: #seekAllChangesOn:onInstanceVariable:
			argumentList: {
					object.
					varName } ].
	^ menu
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> seekAllChanges: anObject [

	anObject seekAndDisplayAllMyChanges  
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> seekAllChangesOn: anObject onInstanceVariable: varName [

	anObject seekAndDisplayAllMyChangesOfVariableNamed: varName
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> seekAllMessages: anObject [

	anObject seekAndDisplayAllMessagesSentToMe
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> seekAllMessagesOn: anObject ofSelector: selector [

	anObject seekAndDisplayAllMessagesSentToMeWithSelector: selector
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> timeTravelToInstantiationOf: anObject [

	| oid seeker |
	seeker := anObject seekMe.
	seeker ifNil: [ ^ self ].
	oid := anObject seekMyOid.
	anObject ifNil: [ ^ self ].
	seeker timeTravelToBytecodeIndex: oid
]
