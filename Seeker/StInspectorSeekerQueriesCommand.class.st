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

	| menu |
	menu := MenuMorph new.

	menu
		add: 'List all messages sent to the inspected object'
		target: self
		selector: #seekAllMessages:
		argument: self model inspectedObject.
	menu
		add:
		'List all assignment to the instance variables of the inspected object'
		target: self
		selector: #seekAllChanges:
		argument: self model inspectedObject.
	menu invokeModal
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> seekAllChanges: anObject [

	anObject seekAndDisplayAllMessagesSentToMe  
]

{ #category : #'as yet unclassified' }
StInspectorSeekerQueriesCommand >> seekAllMessages: anObject [

	anObject seekAndDisplayAllMyChanges
]
