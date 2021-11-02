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

	| res oid selectedNode obj selectedContext |
	selectedContext := self tracer selectedContext.
	selectedNode := self tracer selectedNode.
	selectedNode ifNil: [ ^ self error: 'No variable selected' ].
	selectedNode isVariable ifFalse: [ 
		^ self error: 'Only works for variables' ].
	obj := selectedContext readVariableNamed: selectedNode variable name.
	oid := self tracer readAliasOf: obj.
	res := (self tracer find allMessageSendsToOid: oid)
		       asSeekerResultsCollection forMessageSends.

	self showResult: res
	"	self showResult:
		( cullFieldsWithMapping: { 
				 (#bytecodeIndex -> #ebc).
				 (#messageSelector -> #sel).
				 (#messageReceiverClass -> #class).
				 (#messageArguments -> #args) } asDictionary)"
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
