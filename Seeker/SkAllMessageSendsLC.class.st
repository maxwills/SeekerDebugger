Class {
	#name : #SkAllMessageSendsLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message>. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #executing }
SkAllMessageSendsLC >> executeCommand [

	| query queryDisplayModel columns |
	query := self tracer queries forMessageSends collect:
		         SeekerProjectionFunctions projectionForMessageSends.
	queryDisplayModel := QueryDisplayModel newForQuery: query.
	columns := { 
		           (ColumnDefinition newForKey: #bytecodeIndex).
		           (ColumnDefinition newForKey: #methodSelector) }.
	queryDisplayModel columns: columns.


	self showResultFor: queryDisplayModel
]

{ #category : #accessing }
SkAllMessageSendsLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)
history
objects
smallLoadProject
smallPushpin
"
"#glamorousSaveToUrl"
	^ #smallExport
]

{ #category : #accessing }
SkAllMessageSendsLC >> name [

	^'All Message Sends'
]
