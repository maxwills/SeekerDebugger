Extension { #name : #OCBytecodeToASTCache }

{ #category : #'*Seeker' }
OCBytecodeToASTCache >> ordinalIndexOf: node [

	(self xpropAt: #ordinalIndices) ifNil: [ self ordinatedNodes ].
	^ (self xpropAt: #ordinalIndices) at: node ifAbsent: nil "This happens when a block is inlined (The is no bytecode for the BlockNode)"
]

{ #category : #'*Seeker' }
OCBytecodeToASTCache >> ordinatedNodes [

	| ordinatedNodes ordinalIndices counter |
	ordinatedNodes := self xpropAt: #ordinatedNodes.
	ordinatedNodes ifNotNil: [ ^ ordinatedNodes ] ifNil: [ 
		| prevNode |
		ordinatedNodes := OrderedCollection new.
		ordinalIndices := WeakIdentityKeyDictionary new.
		counter := 0.
		prevNode := nil.
		firstBcOffset to: lastBcOffset do: [ :index | 
			| node |
			"Sometimes the two bytecodes are mapped to the same node. We only consider the first map."
			node := bcToASTMap at: index.
			node == prevNode ifFalse: [ 
				counter := counter + 1.
				ordinatedNodes add: node.
				ordinalIndices at: node put: counter ].
			prevNode := node ].
		self xpropAt: #ordinalIndices put: ordinalIndices.
		self xpropAt: #ordinatedNodes put: ordinatedNodes.
		^ ordinatedNodes ]
]

{ #category : #'*Seeker' }
OCBytecodeToASTCache >> statementIndexOf: node [

	(self xpropAt: #statementIndices) ifNil: [ self statements ].
	^ (self xpropAt: #statementIndices)
		  at: node statementNode
		  ifAbsent: nil ""
]

{ #category : #'*Seeker' }
OCBytecodeToASTCache >> statements [

	| statements |
	statements := self xpropAt: #statementIndices.
	statements ifNotNil: [ ^ statements ] ifNil: [ 
		| actualStatements |
		statements := WeakIdentityKeyDictionary new.
		actualStatements := methodOrBlockNode statements.
		"generating the reverse index"
		actualStatements ifNotEmpty: [ 
			1 to: actualStatements size do: [ :index | 
			statements at: (actualStatements at: index) put: index ] ].
		self xpropAt: #statementIndices put: statements.
		^ statements ]
]
