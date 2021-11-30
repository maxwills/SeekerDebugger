Class {
	#name : #SkAllMessageSendsToObjectInVariableLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllMessageSendsToObjectInVariableLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <sent message> to the selected object. Every listed result corresponds to the moment before performing the message send. (Sender''s point of view)'
]

{ #category : #executing }
SkAllMessageSendsToObjectInVariableLC >> executeCommand [

	| oid |
	oid := self getSelectedObjectOid.

	self showResultFor: (TTQAllMessagesSentToObject
			 queryFrom: self tracer programStates
			 withObjectOid: oid)
]

{ #category : #accessing }
SkAllMessageSendsToObjectInVariableLC >> icon [

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
SkAllMessageSendsToObjectInVariableLC >> name [

	^ 'All Messages sent to the selected object'
]
