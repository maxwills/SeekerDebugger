Class {
	#name : #SkObjectAliasFromReceiverLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkObjectAliasFromReceiverLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkObjectAliasFromReceiverLC >> executeCommand [

	| objectAlias |
	self seeker stepper mapExecutionIfNotMappedAlready ifFalse: [ ^self inform: 'Unable to execute Seeker command in unmapped execution' ].
	objectAlias := self seeker stepper getObjectAliasFor:
		               self seeker stepper
			               createObjectAliasForCurrentReceiver.
	Smalltalk tools inspector openOn: objectAlias asCode
]

{ #category : #accessing }
SkObjectAliasFromReceiverLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkObjectAliasFromReceiverLC >> name [

	^'Get Object Alias from Receiver'
]
