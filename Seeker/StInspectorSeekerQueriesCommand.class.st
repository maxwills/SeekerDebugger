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

	| menu object |
	object := self model inspectedObject.
	menu := MenuMorph new.

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
	menu invokeModal
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
