"
Basically a collection of Statements Static ID.
"
Class {
	#name : #SkStepDescriptor,
	#superclass : #OrderedCollection,
	#instVars : [
		'executionIndex',
		'sourceCode',
		'extraInfo',
		'astSteps',
		'isReturning'
	],
	#category : #'Seeker-Components'
}

{ #category : #'as yet unclassified' }
SkStepDescriptor class >> currentNodeOf: aContext [
	^ aContext method sourceNodeForPC: aContext pc
]

{ #category : #'instance creation' }
SkStepDescriptor class >> newFromContext: aContext withPrevious: aStepDescriptor [

	"returns a SDStatementStepDescriptor with all the statement static IDs which lead to the nodenode"

	| newDepth depthDiff |
	aStepDescriptor ifNil: [ "Do slow version"
		^ self
			  newFromNode:
			  (SkContextHelpers currentNodeOf: aContext isTopContext: true)
			  inContext: aContext
			  isTopContext: true ].
	newDepth := SkContextHelpers countStackDepthFrom: aContext.
	depthDiff := newDepth - aStepDescriptor size.
	depthDiff abs <= 1
		ifTrue: [ "Optimized version"
			| newStep |
			newStep := aStepDescriptor clone.
			[ depthDiff ] switchCase: { 
					([ 1 ] -> [ "doNothing" ]).
					([ -1 ] -> [ 
					 newStep removeLast.
					 newStep removeLast ]).
					(#defaultCase -> [ newStep removeLast ]) }.
			newStep add: (SkStatementStaticID
					 newFromAstNode:
					 (SkContextHelpers currentNodeOf: aContext isTopContext: true)
					 inContext: aContext
					 isTopContext: true).
			^ newStep ]
		ifFalse: [ "Do slow version"
			^ self
				  newFromNode:
				  (SkContextHelpers currentNodeOf: aContext isTopContext: true)
				  inContext: aContext
				  isTopContext: true ]
]

{ #category : #'instance creation' }
SkStepDescriptor class >> newFromCurrentNodeInContext: aContext [

	"returns a SDStatementStepDescriptor with all the statement static IDs which lead to the nodenode"

	^ self
		  newFromNode: (SkContextHelpers currentNodeOf: aContext isTopContext: true)
		  inContext: aContext
		  isTopContext: true
]

{ #category : #'instance creation' }
SkStepDescriptor class >> newFromNode: aRBNode inContext: aContext isTopContext: aBoolean [

	"returns a SDStatementStepDescriptor with all the statement static IDs which lead to the nodenode"

	| stepDescriptor sourceCode contexts lastIteration |
	aContext ifNil: [ Exception new signal ].

	stepDescriptor := self new.
	"current context (top) is the last one"
	contexts := SkContextHelpers contextStackAsListFrom: aContext.
	lastIteration := false.
	1 to: contexts size do: [ :cIndex | 
		| iterationContext statementID iterationNode |
		iterationContext := contexts at: cIndex.
		lastIteration := cIndex = contexts size.
		iterationNode := lastIteration
			                 ifTrue: [ aRBNode ]
			                 ifFalse: [ 
				                 SkContextHelpers
					                 currentNodeOf: iterationContext
					                 isTopContext: false ].
		statementID := SkStatementStaticID
			               newFromAstNode: iterationNode
			               inContext: iterationContext
			               isTopContext: lastIteration.
		stepDescriptor add: statementID ].


	sourceCode := ''. "aRBNode statementNode
		              ifNil: [ '""no statement for node""' ]
		              ifNotNil: [ aRBNode statementNode sourceCode ]."
	stepDescriptor isReturning: aRBNode isReturn.
	stepDescriptor sourceCode: sourceCode.
	stepDescriptor topStatementID isReturning: stepDescriptor isReturning.
	^ stepDescriptor
]

{ #category : #converting }
SkStepDescriptor >> asIndexlessDescriptor [
	|step|
	step := self class new.
	1 to: self size do: [ :index | step add: (self at: index) clone ].
^step.
]

{ #category : #converting }
SkStepDescriptor >> asString [

	^self asStringForCsv
]

{ #category : #converting }
SkStepDescriptor >> asStringForCsv [

	| str |
	str := $> join: (self collect: [ :aEsnToken | ';', aEsnToken asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ self executionIndex asString, ';', str, '; ', (self sourceCode), ' ', (extraInfo ifNil:[''] ifNotNil: [extraInfo])
]

{ #category : #converting }
SkStepDescriptor >> asStringIgnoringLeadingStatements: aNumber [

	| str |
	(self size <= aNumber) ifTrue: [ ^'' ].
	
	str := $> join: ((self allButFirst: aNumber) collect: [ :aEsnToken | ' ', aEsnToken asString ]).
	"self isUnwinding isNotNil and: [ 
		self isUnwinding ifTrue: [ str := str , '+u' ] ]."
	^ self executionIndex asString, '.- ', str, ' - ', (self sourceCode), ' ', (extraInfo ifNil:[''] ifNotNil: [extraInfo])
]

{ #category : #accessing }
SkStepDescriptor >> astSteps [

	^ astSteps
]

{ #category : #accessing }
SkStepDescriptor >> astSteps: anObject [

	astSteps := anObject
]

{ #category : #copying }
SkStepDescriptor >> clone [

	| step |
	step := self class new: self size.
	step executionIndex: self executionIndex.
	step sourceCode: self sourceCode.
	step extraInfo: self extraInfo.
	step astSteps: self astSteps.
	step isReturning: self isReturning.
	self do: [ :each | step add: each clone ].
	^ step
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> comparePathTo: anIndexlessStepDescriptor [

	"Returns -1 if self happens before the paramenter.  0 if they are the same, and 1 if self happens after the parameter. If the root statement sequence is different, then it returns nil (There is no chonologial order if they come from totally different executions.
	Return nil in any other error case."

	| shortestLength |
	"Take care immediately of a border cases."
	anIndexlessStepDescriptor ifNil: [ ^ nil ].
	shortestLength := self size < anIndexlessStepDescriptor size
		                  ifTrue: [ self size ]
		                  ifFalse: [ anIndexlessStepDescriptor size ].
	shortestLength = 0 ifTrue: [ ^ nil ].
	(shortestLength = 1 and: [ 
		 ((self at: 1) sequenceStaticID equalTo:
			  (anIndexlessStepDescriptor at: 1) sequenceStaticID) not ]) 
		ifTrue: [ ^ nil ].
	1 to: shortestLength do: [ :pathIndex | 
		| thisPathStatement othersPathStatement |
		thisPathStatement := self at: pathIndex.
		othersPathStatement := anIndexlessStepDescriptor at: pathIndex.
		(thisPathStatement equalTo: othersPathStatement)
			ifTrue: [ 
				thisPathStatement isReturning ~= othersPathStatement isReturning 
					ifTrue: [ "the returning happens after""keep advancing the index"
						thisPathStatement isReturning
							ifTrue: [ ^ 1 ]
							ifFalse: [ ^ -1 ] ] ]
			ifFalse: [ "There is something different: the sequence or index""See if we are in the same sequence"
				(thisPathStatement sequenceStaticID equalTo:
					 othersPathStatement sequenceStaticID)
					ifTrue: [ "if there is a index as 0, it is a sort of return"
						thisPathStatement indexInSequence = 0 ifTrue: [ ^ 1 ].
						othersPathStatement indexInSequence = 0 ifTrue: [ ^ -1 ].
						^ thisPathStatement indexInSequence
						  < othersPathStatement indexInSequence
							  ifTrue: [ ^ -1 ]
							  ifFalse: [ 
								  ^ 1 "Note that we are skipping the equal case, because it should have been filtered before entering here" ] ]
					ifFalse: [ 
						^ 0 "This is an error case? The index may or maynot be the same, and the sequence is different. I think this will happen in the current state of the project when parameters solve their own inner statements. However, it would be interesting to recocer the common statement in the path. not for now" ] ] ].
	"At this point both paths have in common the shortest path. Then the longest describes what happens after"
	self size = anIndexlessStepDescriptor size ifTrue: [ ^ 0 ].
	self size < anIndexlessStepDescriptor size ifTrue: [ ^ -1 ].
	^ 1
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> directRecursionDepth [

	"1 means there was no recursion (just a single call). 2 means that this the method was called once inside the same method, etc"

	| startingReceiversClass startingMethodSelector indexOfStatementNotInRecursion |
	startingReceiversClass := self receiverClass.
	startingMethodSelector := self methodSelector.
	indexOfStatementNotInRecursion := 0.
	indexOfStatementNotInRecursion := self
		                                  reverseFindStatement: [ 
			                                  :aStatement | 
			                                  | seqId |
			                                  seqId := aStatement
				                                           sequenceStaticID.
			                                  seqId receiverClass
			                                  ~= startingReceiversClass or: [ 
				                                  seqId methodSelector
				                                  ~= startingMethodSelector ] ]
		                                  startingIndex: self size - 1.
	^ self size - indexOfStatementNotInRecursion
]

{ #category : #accessing }
SkStepDescriptor >> executionIndex [

	^ executionIndex
]

{ #category : #accessing }
SkStepDescriptor >> executionIndex: anObject [

	executionIndex := anObject
]

{ #category : #accessing }
SkStepDescriptor >> extraInfo [

	^ extraInfo
]

{ #category : #accessing }
SkStepDescriptor >> extraInfo: anObject [

	extraInfo := anObject
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> getParentIndexlessDescriptor [

	| parentStep |
	parentStep := SkStepDescriptor new.
	1 to: self size - 1 do: [ :index | parentStep add: (self at: index) clone ].
	^ parentStep
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> happensAfterPathOf: anIndexlessStepDescriptor [

	"Returns true if the statement described by self happens before the one in the argument"

	^ (self comparePathTo: anIndexlessStepDescriptor) > 0
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> happensBeforePathOf: anIndexlessStepDescriptor [

	"Returns true if the statement described by self happens before the one in the argument"

	^ (self comparePathTo: anIndexlessStepDescriptor) < 0
]

{ #category : #testing }
SkStepDescriptor >> hasSameIndexlessSignatureAs: aStepDescriptor [
"Need to reaftor this, since it does the same as hasSamePathAs:"
^self hasSamePathAs: aStepDescriptor
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> hasSamePathAs: anSDStatementStepDescriptor [

	(self size == anSDStatementStepDescriptor size) ifFalse: [ ^ false ].
	1 to: self size do: [ :index | 
		| lhsStatement rhsStatement |
		lhsStatement := self at: index.
		rhsStatement := anSDStatementStepDescriptor at: index.
		(lhsStatement equalTo: rhsStatement) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> hasSamePathAs: anSDStatementStepDescriptor upToLevel: aNumber [
self size < aNumber ifTrue: [ ^false ].
anSDStatementStepDescriptor size < aNumber ifTrue: [ ^false ].
	1 to: aNumber do: [ :index | 
		| lhsStatement rhsStatement |
		lhsStatement := self at: index.
		rhsStatement := anSDStatementStepDescriptor at: index.
		(lhsStatement equalTo: rhsStatement) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #initialization }
SkStepDescriptor >> initialize [
	super initialize.
	executionIndex := 0.
	sourceCode := ''.
	astSteps := 0.
	extraInfo := ''.
	isReturning := false.
]

{ #category : #accessing }
SkStepDescriptor >> isReturning [

	^ isReturning
]

{ #category : #accessing }
SkStepDescriptor >> isReturning: anObject [

	isReturning := anObject
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> isSameDynamicSequenceAs: anSDStatementStepDescriptor [

	self size == anSDStatementStepDescriptor size ifFalse: [ ^ false ].
	1 to: self size do: [ :index | 
		| lhsStatement rhsStatement |
		lhsStatement := self at: index.
		rhsStatement := anSDStatementStepDescriptor at: index.
		index = self size
			ifFalse: [ 
			(lhsStatement equalTo: rhsStatement) ifFalse: [ ^ false ] ]
			ifTrue: [ 
				(lhsStatement isInSameSequenceAs: rhsStatement) ifFalse: [ 
					^ false ] ] ].

	^ true
]

{ #category : #testing }
SkStepDescriptor >> isSiblingOf: aStepDescriptor [

	"Returns true if this stepDescriptor belongs to the same sequence as the parameter. As in instanced sequence, dynamic, not static (Same node in the execution graph)"

	(self size == aStepDescriptor size) ifFalse: [ ^ false ].
	1 to: self size do: [ :index | 
		| lhsStatement rhsStatement |
		lhsStatement := self at: index.
		rhsStatement := aStepDescriptor at: index.
		(index = self size)
			ifFalse: [ "not the last path token. Compare consider also the index in sequence" 
				(lhsStatement equalTo: rhsStatement) ifFalse: [ ^ false ] ]
			ifTrue: [ "The last token of the path. We ignore the index in the sequence for the comparison"
				(lhsStatement sequenceStaticID equalTo:
					 rhsStatement sequenceStaticID) ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #accessing }
SkStepDescriptor >> methodName [ 
	^ self last sequenceStaticID methodName
]

{ #category : #accessing }
SkStepDescriptor >> methodSelector [
	^ self last sequenceStaticID methodSelector
]

{ #category : #'as yet unclassified' }
SkStepDescriptor >> pathDepth [
	^ self size
]

{ #category : #accessing }
SkStepDescriptor >> receiverClass [
	^ self last sequenceStaticID receiverClass
]

{ #category : #accessing }
SkStepDescriptor >> receiverClassName [ 
	^ self last sequenceStaticID receiverClassName
]

{ #category : #accessing }
SkStepDescriptor >> reverseFindStatement: aBlock startingIndex: aNumber [
"aBlock is predicate for a StatementStaticID. If it evaluates to true, the index of such statement is returned"
	|statementStaticID|
	(aNumber > self size) ifTrue: [ ^ 0 ].
	(aNumber <= 0) ifTrue: [ ^0 ].
	statementStaticID := self at: aNumber.
	(aBlock value: statementStaticID) ifTrue: [ ^aNumber ].
	^self reverseFindStatement: aBlock startingIndex: aNumber -1.
]

{ #category : #accessing }
SkStepDescriptor >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
SkStepDescriptor >> sourceCode: anObject [

	sourceCode := anObject
]

{ #category : #converting }
SkStepDescriptor >> topStatementID [
^ self last
]

{ #category : #converting }
SkStepDescriptor >> topStatementName [
^ self last
]
