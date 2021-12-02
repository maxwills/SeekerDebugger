Extension { #name : #Array }

{ #category : #'*Seeker' }
Array >> << aSequenceableCollection [

	"Unpacks a aSequenceableCollection into the variables hosted by the array"

	"Meta-programming... Avoid debugging this."

	| context messageNode msgReceiverNode varNodes |
	aSequenceableCollection isEmpty ifTrue: [ 
		^ self error: 'unpack: argument is empty' ].
	self isEmpty ifTrue: [ 
		^ self error: 'unpack: receiver variables array is empty' ].
	self size = aSequenceableCollection size ifFalse: [ 
		^ self error:
			  'unpack: receiver variables array  size and argument size do not match.' ].
	context := thisContext sender.
	context pc ifNil: [ ^ nil ].
	messageNode := context method sourceNodeForPC: context executedPC.
	msgReceiverNode := messageNode receiver.
	varNodes := msgReceiverNode statements.
	varNodes do: [ :each | "checks"
		| eachClass |
		eachClass := each class.
		(eachClass == RBVariableNode or: [ 
			 eachClass == RBLiteralValueNode and: [each value isNil] ]) ifFalse: [ 
			^ self error: 'unpack: wrong types' ] ].
	1 to: varNodes size do: [ :i | 
		| varNode |
		varNode := varNodes at: i.
		varNode class == RBVariableNode ifTrue: [ 
			context
				writeVariableNamed: varNode name
				value: (aSequenceableCollection at: i) ]
		"All other type of nodes are ignored" ].
	^ self
]

{ #category : #'*Seeker' }
Array >> asSkXAnonymousType [
	AnonymousType newWith: self
]

{ #category : #'*Seeker' }
Array >> doCase: anExpression [

| exprValue defaultCaseBlock |
	exprValue := anExpression value.
	defaultCaseBlock := nil.
	self do: [ :each | 
		| key |
		key := each key value.
		key = exprValue ifTrue: [ ^ each value value ].
		key = #defaultCase ifTrue: [ defaultCaseBlock := each value ] ].
	defaultCaseBlock ifNotNil: [ ^ defaultCaseBlock value ].
	^ self error:
		  'doCase error. No matching case key or defaultCase found'
]
