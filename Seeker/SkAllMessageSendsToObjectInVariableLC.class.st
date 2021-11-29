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

	| oid selectedNode obj objClass selectedContext query queryDisplayModel |
	selectedContext := self tracer selectedContext.
	selectedNode := self tracer selectedNode.
	selectedNode ifNil: [ ^ self error: 'No variable selected' ].
	selectedNode isVariable ifFalse: [ 
		^ self error: 'Only works for variables' ].
	obj := selectedContext readVariableNamed: selectedNode variable name.
	objClass := obj class.
	oid := self tracer getOidOf: obj.

	query := self tracer queries forMessageSends
		         select: [ :state | 
			         state messageReceiver class == objClass "innecessary, but it's faster than getting the oid"and: [ 
				         state messageReceiverOid == oid ] ]
		         collect: SkProjectionMessageSends new.
	queryDisplayModel := QdmForMessageSends newForQuery: query.

	self showResultFor: queryDisplayModel
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
