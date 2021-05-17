Class {
	#name : #SkAnonymousTypeHelpers,
	#superclass : #Object,
	#category : #'Seeker-Helpers'
}

{ #category : #compiling }
SkAnonymousTypeHelpers class >> compileCode: aString inContext: aContext [

	^ aContext receiver class compiler
		  source: aString;
		  context: aContext;
		  receiver: aContext receiver;
		  requestor: nil;
		  failBlock: [ nil ];
		  evaluate
]

{ #category : #compiling }
SkAnonymousTypeHelpers class >> compileNewSimplifiedBlockFor: aBlock withStatements: aCollection [

	| templateBlockString innerArrayString newBlockSourceCode |
	templateBlockString := [ New with: { #replaceThis } ] asString.
	innerArrayString := $. join:
		                    (aCollection collect: [ :node | node sourceCode ]).
	newBlockSourceCode := templateBlockString
		                      copyReplaceAll: '#replaceThis'
		                      with: innerArrayString.
	^ self compileCode: newBlockSourceCode inContext: aBlock asContext
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> filterKeepingFields: aCollection andExcluding: aCollectionForExclusion ofInstantiationBlock: aBlock [

	"Compiles a new block of anonymous type instantiation, removing fields not included in the collection parameter"

	"Exclusion has priority over exclusion. Filters can't add what is not there!"

	| ast anonInstantiationMessageNodes anonInstantiationNode arrayNode filteredStatements |
	(aCollection isEmpty and: [ aCollectionForExclusion isEmpty ]) 
		ifTrue: [ ^ aBlock ].

	ast := aBlock sourceNode. " ast"
	anonInstantiationMessageNodes := ast sendNodes select: [ :node | 
		                                 self 
			                                 isAnonymousTypeInstantiationNode:
			                                 node ].

	anonInstantiationMessageNodes ifEmpty: [ "can't optimize this node" 
		^ false ].
	anonInstantiationNode := anonInstantiationMessageNodes last.
	anonInstantiationNode arguments size ~= 1 ifTrue: [ ^ aBlock ].
	arrayNode := anonInstantiationNode arguments first.
	filteredStatements := self
		                      filterStatementsNodes: arrayNode statements
		                      whileKeeping: aCollection
		                      andExcluding: aCollectionForExclusion.
	arrayNode statements size = filteredStatements size ifTrue: [ 
		^ aBlock "Nothing to filter out" ].
	^ self
		  compileNewSimplifiedBlockFor: aBlock
		  withStatements: filteredStatements
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> filterKeepingFields: aCollection ofInstantiationBlock: aBlock [

	"Compiles a new block of anonymous type instantiation, removing fields not included in the collection parameter"

	| ast anonInstantiationMessageNodes anonInstantiationNode arrayNode filteredStatements |
	aCollection ifEmpty: [ ^ aBlock ].

	ast := aBlock sourceNode. " ast"
	anonInstantiationMessageNodes := ast sendNodes select:
		                                 [:node| self isAnonymousTypeInstantiationNode: node].
		
	anonInstantiationMessageNodes ifEmpty: [ "can't optimize this node" 
		^ false ].
	anonInstantiationNode := anonInstantiationMessageNodes last.
	anonInstantiationNode arguments size ~= 1 ifTrue: [ ^ aBlock ].
	arrayNode := anonInstantiationNode arguments first.
	filteredStatements := self
		                      filterStatementsNodes: arrayNode statements
		                      listOfFieldsToKeep: aCollection.
	arrayNode statements size = filteredStatements size ifTrue: [ 
		^ aBlock "Nothing to filter out" ].
	^ self
		  compileNewSimplifiedBlockFor: aBlock
		  withStatements: filteredStatements
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> filterOutStatementsNodes: anArrayOfStatements listOfFieldsToRemove: aCollection [

	| filteredStatements |
	filteredStatements := anArrayOfStatements select: [ :each | 
		                      each isMessage
			                      ifFalse: [ true ]
			                      ifTrue: [ 
				                      | fieldName |
				                      fieldName := each receiver value.
				                      (aCollection includes: fieldName) not ] ].
	^ filteredStatements
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> filterRemovingFields: aCollection ofInstantiationBlock: aBlock [

	| ast anonInstantiationMessageNodes anonInstantiationNode isAnonInstantiationNode arrayNode filteredStatements |
	aCollection ifEmpty: [ ^ aBlock ].
	isAnonInstantiationNode := [ :node "aMessageNode" | 
	                           | receiver |
	                           receiver := node receiver.
	                           receiver isVariable and: [ 
		                           receiver name = New asString asSymbol 
			                           and: [ node selector value = #with: ] ] ].
	ast := aBlock sourceNode. " ast"
	anonInstantiationMessageNodes := ast sendNodes select:
		                                 isAnonInstantiationNode.
	anonInstantiationMessageNodes ifEmpty: [ "can't optimize this node" 
		^ false ].
	anonInstantiationNode := anonInstantiationMessageNodes last.
	anonInstantiationNode arguments size ~= 1 ifTrue: [ ^ aBlock ].
	arrayNode := anonInstantiationNode arguments first.
	filteredStatements := self
		                      filterOutStatementsNodes: arrayNode statements
		                      listOfFieldsToRemove: aCollection.
	arrayNode statements size = filteredStatements size ifTrue: [ 
		^ aBlock "Nothing to filter out" ].
	^ self
		  compileNewSimplifiedBlockFor: aBlock
		  withStatements: filteredStatements
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> filterStatementsNodes: anArrayOfStatements listOfFieldsToKeep: aCollection [

	| filteredStatements |
	filteredStatements := anArrayOfStatements select: [ :each | 
		                      each isMessage
			                      ifFalse: [ true ]
			                      ifTrue: [ 
				                      | fieldName |
				                      fieldName := each receiver value.
				                      aCollection includes: fieldName  ] ].
	^ filteredStatements
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> filterStatementsNodes: anArrayOfStatements whileKeeping: aCollection andExcluding: aCollectionToExclude [

	| filteredStatements |
	filteredStatements := anArrayOfStatements select: [ :each | 
		                      each isMessage
			                      ifFalse: [ true ]
			                      ifTrue: [ 
				                      | fieldName |
				                      fieldName := each receiver value.
				                      (aCollection isEmpty or: [ 
					                       aCollection includes: fieldName ]) and: [ 
					                      (aCollectionToExclude includes: fieldName)
						                      not ] ] ].
	^ filteredStatements
]

{ #category : #testing }
SkAnonymousTypeHelpers class >> isAnonymousTypeInstantiationNode: anRBNode [

	| receiver |
	anRBNode isMessage ifFalse: [ ^ false ].

	receiver := anRBNode receiver.
	^ receiver isVariable and: [ 
		  receiver name = New asString asSymbol and: [ 
			  anRBNode selector value = #with: ] ]
]

{ #category : #'as yet unclassified' }
SkAnonymousTypeHelpers class >> listOfFieldsInAnonymousTypeBlock: aBlock [

	"aBlock is a Block (Block closure) that recives one one argument which is expected to be an anonymous type object. This methods anaylizes the static ast of said block, and return all the fields names accessed for the argument "

	| setOfFields blockNode argument |
	aBlock ifNil: [ ^ {  } ].
	setOfFields := Set new.
	blockNode := aBlock sourceNode.
	blockNode arguments size ~= 1 ifTrue: [ 
		^ setOfFields "unsupported block. The block should have only one argument" ].
	argument := (blockNode arguments at: 1) name. "the first argument is a variable node"
	blockNode sendNodes do: [ :each | 
		(each receiver isVariable and: [ each receiver name = argument ]) 
			ifTrue: [ setOfFields add: each selector ] ].
	"recursive step"
	blockNode body allVariables do: [ :var | 
		| varValue |
		varValue := aBlock asContext readVariableNamed: var variable name. "var variableValueInContext: aBlock asContext" "this might fail. should I try catch it?"
		(varValue class inheritsFromOrSameAs: BlockClosure) ifTrue: [ 
			setOfFields addAll:
				(self listOfFieldsInAnonymousTypeBlock: varValue) ] ].
	"c sourceNode allVariables first variableValueInContext: c outerContext sourceNode"
	^ setOfFields asArray
]
