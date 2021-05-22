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

	| ordinatedNodes ordinalIndices |
	ordinatedNodes := self xpropAt: #ordinatedNodes.
	ordinatedNodes ifNotNil: [ ^ ordinatedNodes ] ifNil: [ 
		ordinatedNodes := OrderedCollection new.

		self methodNode method symbolicBytecodes do: [ :each | 
			ordinatedNodes add: each sourceNode ].

		ordinalIndices := WeakIdentityKeyDictionary new.
		ordinatedNodes ifNotEmpty: [ 
			1 to: ordinatedNodes size do: [ :index | 
			ordinalIndices at: (ordinatedNodes at: index) put: index ] ].
		self xpropAt: #ordinalIndices put: ordinalIndices.
		self xpropAt: #ordinatedNodes put: ordinatedNodes.
		^ ordinatedNodes ]
]
