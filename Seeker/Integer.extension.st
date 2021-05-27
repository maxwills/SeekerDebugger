Extension { #name : #Integer }

{ #category : #'*Seeker' }
Integer >> asExecutedBytecodeTraceTime [

	^ SkExecutedBytecodeTraceTimeReference new executedBytecode: self
]

{ #category : #'*Seeker' }
Integer >> nthBytecode [

	^ SkXBytecodeIndex new index: self
]

{ #category : #'*Seeker' }
Integer >> nthStatement [

	^ SkXStatementIndex new index: self
]
