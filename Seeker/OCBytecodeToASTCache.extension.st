Extension { #name : #OCBytecodeToASTCache }

{ #category : #'*Seeker' }
OCBytecodeToASTCache >> ordinalIndexOf: node [

	(self xpropAt: #ordinalIndices) ifNil: [ self ordinatedNodes ].
	^ (self xpropAt: #ordinalIndices)
		  at: node
		  ifAbsent: nil
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
