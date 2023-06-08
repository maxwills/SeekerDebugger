Extension { #name : #CompiledCode }

{ #category : #'*Seeker' }
CompiledCode >> @ aNumberOrNodeIndex [

	"In the future this will be extended to suppory other expression (#last, etc)"

	aNumberOrNodeIndex isNumber ifTrue: [ "Consider it as if it is a bytecode index" 
		^ aNumberOrNodeIndex nthBytecode findIn: self ].
	(aNumberOrNodeIndex class inheritsFrom: SkXNodeIndex) ifTrue: [ 
		^ aNumberOrNodeIndex findIn: self ].
	^ self error: 'unsupported argument type'
]

{ #category : #'*Seeker' }
CompiledCode >> bytecodeNodes [

	"Don't modify this. Should return a copy instead?"

	^ self ast bcToASTCache ordinatedChildren
]

{ #category : #'*Seeker' }
CompiledCode >> ordinatedNodes [

	^ self sourceNode ordinatedChildren
]

{ #category : #'*Seeker' }
CompiledCode >> softEqualTo: aCompiledMethod withCache: objs [

	self == aCompiledMethod
		ifTrue: [ ^ true ].
	self class = aCompiledMethod class
		ifFalse: [ ^ false ].
	self size = aCompiledMethod size
		ifFalse: [ ^ false ].
	self header = aCompiledMethod header
		ifFalse: [ ^ false ].
	self initialPC to: self endPC do: [ :i |
		(self at: i) = (aCompiledMethod at: i)
			ifFalse: [ ^ false ] ].
	(self sameLiteralsAs: aCompiledMethod)
		ifFalse: [ ^ false ].
	^ true
 
]

{ #category : #'*Seeker' }
CompiledCode >> statementNodes [

	"Don't modify this. Should return a copy instead?"

	^ self ast statements
]
