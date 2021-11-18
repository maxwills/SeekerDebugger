Class {
	#name : #SeekerTraceQueriesInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> baseQuery [

	"returns a Current State Interface based query"

	"Note that this will not work on it's own. It still lacks a select and collect.
For time travel, it needs the executedBytecode field to be a part of each result item.
"

	^ Query from: tracer programStates
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> baseQueryForAssignments [

	"A base query. Don't launch it like this. A collectionBlock is needed for this to produce results"

	^ Query
		  from: tracer programStates
		  select: [ :state | state node isAssignment ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> baseQueryForInstancesCreation [

	^ Query
		  from: tracer programStates
		  select: [ :state | state isInstantiationMessage ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> baseQueryForMessageSends [

	"A base query. Don't launch it like this. A collectionBlock is needed for this to produce results"

	^ Query
		  from: tracer programStates
		  select: [ :state | state isMessageSend ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> baseQueryOld [

	"returns a query upon the omniscientTable"
	"Discontinued. Use instead baseCsiQuery or directly use programStates as dataSource"

	^ Query from: tracer tables omniscientTable
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAliasOfContextReceiverAtStepIndex: aNumber [

	"How to use it
	 |step|
step :=  seeker currentIndexlessStepDescriptor .
(seeker queries forAliasOfContextReceiverWithStepDescriptorPath:step) first"

	| q |
	self error: 'should not used'.
	q := Query
		     from: tracer tables omniscientTableForAliases
		     select: [ :row | row stepIndex = aNumber ]
		     collect: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverAlias -> row receiverAlias).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAliasOfObjectReferredByVariableNode: aVariableNode [

	| q table |
	self error: 'should not used'.
	table := tracer tables omniscientTableForAliases.
	q := Query
		     from: table
		     where: [ :row | 
			     row node isVariable and: [ 
				     row node variable name = aVariableNode variable name ] ]
		     select: [ :row | 
			     | variableValue getAlias |
			     variableValue := row context readVariableNamed:
				                      aVariableNode variable name.
			     "Note: dont do this:
				 getAlias := [:arg |
			                 arg aliasesDictionary
				                 at: variableValue
				                 ifAbsent: [ nil ] ].
				Since arg is not the argument of the select block, #aliasesDictionary will not be considered 
				as a relevant field and will not be included in the input row. (unless it is protected).
				Do this instead:
				"
			     getAlias := [ 
			                 row aliasesDictionary
				                 at: variableValue
				                 ifAbsent: [ nil ] ].
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#valueClass -> variableValue class).
					     (#variableName -> aVariableNode variable name).
					     (#variableValue -> variableValue).
					     (#variableValueAlias -> getAlias value).
					     (#instance -> variableValue).
					     (#aliases -> row aliasesDictionary) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAliasOfObjectReferredByVariableNode: aVariableNode atContextOfStepPath: aStepDescriptorForContextOfVariable atExecutionStepIndex: aNumber [

	"The logic here is that the execution must remember the context where the node is located, but the alias must be evaluated once the execution reaches the step aNumber"

	| q table contextOfVariable |
	contextOfVariable := nil.
	self error: 'should not used'.
	table := tracer tables omniscientTableForAliases.
	q := Query
		     from: table
		     where: [ :row | 
			     (row tracedStatementDescriptor isSameDynamicSequenceAs:
				      aStepDescriptorForContextOfVariable) ifTrue: [ 
				     contextOfVariable := row context ].
			     row stepIndex = aNumber ]
		     select: [ :row | 
			     | variableValue getAlias |
			     variableValue := contextOfVariable readVariableNamed:
				                      aVariableNode variable name.
			     "Note: dont do this:
				 getAlias := [:arg |
			                 arg aliasesDictionary
				                 at: variableValue
				                 ifAbsent: [ nil ] ].
				Since arg is not the argument of the select block, #aliasesDictionary will not be considered 
				as a relevant field and will not be included in the input row. (unless it is protected).
				Do this instead:
				"
			     getAlias := [ 
			                 row aliasesDictionary
				                 at: variableValue
				                 ifAbsent: [ nil ] ].
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#valueClass -> variableValue class).
					     (#variableName -> aVariableNode variable name).
					     (#variableValue -> variableValue).
					     (#variableValueAlias -> getAlias value).
					     (#instance -> variableValue).
					     (#aliases -> row aliasesDictionary) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAliases [

	| q aliasesTable methodsTable |
	aliasesTable := tracer tables tableOfAliases.
	methodsTable := tracer tables tableOfMethods.

	"aliasTable columns: #stepIndex #creationStep #bytecodeIndex "
	"methodsTable columuns: #stepIndex #receiverClass #methodSelector #bytecodeIndex"
	self error: 'should not used'.
	q := Query
		     from: (methodsTable join: aliasesTable)
		     where: [ :row | "row isFirstBytecode" 
			     true "and: [ row methodSelector = #initialize ]" ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#receiverClass -> row receiverClass).
					     (#methodSelector -> row methodSelector).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#alias -> row receiverAlias) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAssignmentsOfAnyVariable [

	| t |
	t := AutoType new.
	^ self baseQueryForAssignments collect: [ :state | 
		  t newWith
			  methodSelector: state methodSelector;
			  receiverClass: state receiverClass;
			  receiverClassAndPackage:
				  state receiverClass name , ' [' , state receiverPackage name
				  , ']';
			  bytecodeIndex: state bytecodeIndex;
			  node: state node;
			  receiverAlias: state receiverAlias;
			  variableNode: state node variable;
			  variableName: state node variable variable name;
			  valueChangedFrom:
				  (state node variable variable readInContext: state context);
			  valueChangedTo: (state context at: state context basicSize);
			  receiverPackage: state receiverPackage;
			  variableClass: state node variable variable class;
			  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAssignmentsOfInstanceVariables [

	| t |
	t := AutoType new.
	^ self baseQueryForAssignments
		  select: [ :state | 
		  state node variable variable isInstanceVariable ]
		  collect: [ :state | 
			  t newWith
				  methodSelector: state methodSelector;
				  receiverClass: state receiverClass;
				  bytecodeIndex: state bytecodeIndex;
				  node: state node;
				  receiverAlias: state receiverAlias;
				  variableNode: state node variable;
				  variableName: state node variable variable name;
				  receiverPackage: state receiverPackage;
				  receiverClassAndPackage:
					  state receiverClass name , ' [' , state receiverPackage name
					  , ']';
				  valueChangedFrom:
					  (state node variable variable readInContext: state context);
				  valueChangedTo: (state context at: state context basicSize);
				  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forContextSizeChanges [

	| table q |
	table := tracer tables tableOfContextSizes asTableWithMemory.
	"The virtual table have this columns : 
     #stepIndex
     #receiverClass
	  #methodSelector
	  #bytecodeIndex
	  #contextSize 
	  #previousRow"
	self error: 'should not used'.
	q := Query
		     from: table
		     where: [ :row | row contextSize ~= row previousRow contextSize ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#contextSizeBefore -> row previousRow contextSize).
					     (#contextSizeNow -> row contextSize) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forExceptionInstancesCreation [

	^ self forInstancesCreation select: [ :state | 
		  state messageReceiver inheritsFromOrSameAs: Exception ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forExceptionSignals [

	| q table |
	table := tracer tables omniscientTableForAliases.
	self error: 'should not be used'.
	q := Query
		     from: table
		     select: [ :row | 
			     row isExceptionSignaledMethod and: [ 
				     row isFirstBytecodeOfMethod ] ]
		     collect: [ :row | 
			     New with: { 
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#messageText -> row receiver messageText) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forInstanceVariables [

	| q table t |
	self error: 'should not be used'.
	table := tracer tables omniscientTableForAliases.
	t := AutoType new.
	q := Query
		     from: table
		     select: [ :row | 
			     row nodeIsVariable and: [ 
				     row node variable isInstanceVariable ] ]
		     collect: [ :row | 
			     | variable |
			     variable := row node variable.
			     t newWith
				     stepIndex: row stepIndex;
				     "(#aliasesDictionary -> row aliasesDictionary)."
				     methodSelector: row methodSelector;
				     receiverClass: row receiverClass;
				     receiverAlias: row receiverAlias;
				     "the receiver is the owner of the variable"bytecodeIndex:
					     row bytecodeIndex;
				     node: row node;
				     variable: variable;
				     isInstanceVariable: variable isInstanceVariable;
				     "(#ownerAlias -> (row aliasesDictionary at: row receiver ifAbsent: [nil]))."
				     context: row context;
				     endWith ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forInstancesCreation [

	| t |
	t := AutoType new.
	^ self baseQueryForInstancesCreation collect: [ :state | 
		  | msgRcvrClass msgRcvrPackage instMsgReceiver |
		  instMsgReceiver := state context at:
			                     state context stackPtr - state node numArgs. "Heuristics"
		  msgRcvrClass := instMsgReceiver.
		  msgRcvrPackage := instMsgReceiver isClass
			                    ifTrue: [ instMsgReceiver package name ]
			                    ifFalse: [ instMsgReceiver class package name ].
		  t newWith
			  bytecodeIndex: state bytecodeIndex;
			  methodSelector: state methodSelector;
			  receiverClass: state receiverClass;
			  messageReceiver: instMsgReceiver;
			  messageArguments: state node arguments;
			  messageReceiverClass: msgRcvrClass class;
			  messageSelector: state node selector;
			  messageReceiverPackage: msgRcvrPackage;
			  creationFormattedDescription: (instMsgReceiver isClass
					   ifTrue: [ instMsgReceiver name ]
					   ifFalse: [ instMsgReceiver class name ]) , ' ['
				  , msgRcvrPackage , ']';
			  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forMarkers [

	| t |
	t := AutoType new.
	^ self baseQuery
		  select: [ :state | 
			  state isMessageSend and: [ state messageIsSeekerMarkerMethod ] ]
		  collect: [ :state | 
			  | arg |
			  arg := state node arguments isNotEmpty
				         ifTrue: [ (state messageArgumentAt: 1) asString ]
				         ifFalse: [ '' ].
			  t newWith
				  bytecodeIndex: state bytecodeIndex;
				  senderMethodClass: state context sender methodClass;
				  senderMethodSelector: state context sender methodSelector;
				  markerArg: arg;
				  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forMessageSends [

	^ self baseQueryForMessageSends
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forMessageSendsBak [

	^ self baseQueryForMessageSends collect: [ :row :newType | 
		  | msgRcvrNode msgRcvrClass msgRcvr |
		  msgRcvrNode := row node receiver.
		  msgRcvr := row messageReceiver.

		  msgRcvrClass := msgRcvr class.
		  newType
			  bytecodeIndex: row bytecodeIndex;
			  methodSelector: row methodSelector;
			  receiverClass: row receiverClass;
			  messageArguments: row node arguments;
			  messageReceiver: msgRcvr;
			  formattedMessageReceiver: (msgRcvrNode isVariable
					   ifTrue: [ 
						   msgRcvrNode variable name , ' ('
						   ,
							   (msgRcvrNode variable readInContext: row context) class
								   asString , ')' ]
					   ifFalse: [ 
						   [ msgRcvr asString , ' (' , msgRcvrNode sourceCode , ')' ] 
							   onErrorDo: [ "msgRcvr" msgRcvrNode sourceCode ] ]);
			  messageReceiverClass: msgRcvrClass value;
			  messageSelector: row node selector;
			  yourself ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReceivedMessages [

	| t |
	t := AutoType new.
	^ Query
		  from: tracer programStates
		  select: [ :state | state contextPC = state initialPC ]
		  collect: [ :state | 
			  t newWith
				  bytecodeIndex: state bytecodeIndex;
				  methodSelector: state methodSelector;
				  receiverClass: state receiverClass;
				  arguments: state context arguments;
				  endWith ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReceivedMessagesB [

	| q table auto |
	auto := AutoType new.
	table := tracer programStates.
	q := Query
		     from: table
		     select: [ :row | row contextPC = row initialPC ]
		     collect: [ :row | 
			     auto newWith: [ :x | 
				     x
					     bytecodeIndex: row bytecodeIndex;
					     methodSelector: row methodSelector;
					     receiverClass: row receiverClass;
					     arguments: row context arguments ] ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReturnValues [

	| q table |
	table := tracer tables omniscientTable.
	self error: 'should not be used'.
	q := Query
		     from: table
		     where: [ :row | row isMethodReturn ]
		     select: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#returnValue -> row methodReturnValue) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReturnValuesOfMethod: aMethod [

	| q methodClass methodSelector |
	self error: 'should not be used'.
	methodClass := aMethod methodClass.
	methodSelector := aMethod selector.

	q := self forReturnValues select: [ :row | 
		     row receiverClass = methodClass and: [ 
			     row methodSelector = methodSelector ] ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReturnValuesOfMethodWithSelector: aSymbol [

	| q |
	self error: 'should not be used'.
	q := self forReturnValues select: [ :row | 
		     row methodSelector = aSymbol ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forVariableValueChanges [

	| q variablesValues |
	variablesValues := self forVariableValues asQueryWithMemory.
	self error: 'should not be used'.
	q := Query
		     from: variablesValues
		     select: [ :row | row value ~= row previousRow value ]
		     collect: [ :row | 
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#variable -> row variable).
					     (#isTempVariable -> row isTempVariable).
					     (#isInstanceVariable -> row isInstanceVariable).
					     (#isLocalVariable -> row isLocalVariable).
					     (#isGlobalVariable -> row isGlobalVariable).
					     (#isSelfVariable -> row isSelfVariable).
					     (#isSuperVariable -> row isSuperVariable).
					     (#alias -> row alias).
					     (#context -> row context).
					     (#valueBefore -> row previousRow value).
					     (#valueNow -> row value) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forVariableValues [

	| q variablesOnly |
	variablesOnly := self forVariables.
	self error: 'should not be used'.
	q := Query from: variablesOnly select: #* collect: [ :row | 
		     New with: { 
				     (#stepIndex -> row stepIndex).
				     (#methodSelector -> row methodSelector).
				     (#receiverClass -> row receiverClass).
				     (#bytecodeIndex -> row bytecodeIndex).
				     (#node -> row node).
				     (#variable -> row variable).
				     (#isTempVariable -> row isTempVariable).
				     (#isInstanceVariable -> row isInstanceVariable).
				     (#isLocalVariable -> row isLocalVariable).
				     (#isGlobalVariable -> row isGlobalVariable).
				     (#isSelfVariable -> row isSelfVariable).
				     (#isSuperVariable -> row isSuperVariable).
				     (#alias -> row alias).
				     (#context -> row context).
				     (#value -> (row variable readInContext: row context)) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forVariables [

	| q table |
	table := tracer tables omniscientTableForAliases.
	self error: 'should not be used'.
	q := Query
		     from: table
		     select: [ :row | row nodeIsVariable ]
		     collect: [ :row | 
			     | variable |
			     variable := row node variable.
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     "(#aliasesDictionary -> row aliasesDictionary)."
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#variable -> variable).
					     (#isTempVariable -> variable isTempVariable).
					     (#isInstanceVariable -> variable isInstanceVariable).
					     (#isLocalVariable -> variable isLocalVariable).
					     (#isGlobalVariable -> variable isGlobalVariable).
					     (#isSelfVariable -> variable isSelfVariable).
					     (#isSuperVariable -> variable isSuperVariable).
					     "(#ownerAlias -> (row aliasesDictionary at: row receiver ifAbsent: [nil]))."
					     (#context -> row context) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> oldForAssignmentsOfInstanceVariables [

	| table q |
	table := tracer tables omniscientTableForAliases.

	q := Query
		     from: table
		     where: [ :row | 
			     row node isAssignment and: [ 
				     row node variable variable isInstanceVariable ] ]
		     select: [ :row | 
			     New with: { 
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#receiverAlias -> row receiverAlias).
					     (#variableNode -> row node variable).
					     (#variableName -> row node variable variable name).
					     (#receiverPackage -> row receiverPackage).
					     (#receiverClassAndPackage
					      ->
					      (row receiverClass name , ' [' , row receiverPackage name
					       , ']')).
					     (#valueChangedFrom
					      -> (row node variable variable readInContext: row context)).
					     (#valueChangedTo -> (row context at: row context basicSize)) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> oldForInstancesCreation [

	| q table |
	table := tracer tables omniscientTableForAliases.

	q := Query
		     from: table
		     select: [ :row | row isInstantiationMessage ]
		     collect: [ :row | 
			     | msgRcvrNode msgRcvr msgRcvrClass msgRcvrPackage |
			     msgRcvrNode := row node receiver.
			     msgRcvr := msgRcvrNode isVariable
				                ifTrue: [ 
				                msgRcvrNode variable readInContext: row context ]
				                ifFalse: [ nil ].
			     msgRcvrClass := msgRcvr
				                     ifNotNil: [ 
					                     msgRcvr isClass
						                     ifTrue: [ msgRcvr ]
						                     ifFalse: [ msgRcvr class] ]
				                     ifNil: [ nil class].
			     msgRcvrPackage := msgRcvrNode isVariable
				                       ifTrue: [ 
					                       msgRcvr isClass
						                       ifTrue: [ msgRcvr package name ]
						                       ifFalse: [ msgRcvr class package name ] ]
				                       ifFalse: [ '#undefined' ].
			     New with: { 
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#messageReceiver -> msgRcvr).
					     (#messageArguments -> row node arguments).
					     (#messageReceiverClass -> msgRcvrClass).
					     (#messageSelector -> row node selector).
					     (#messageReceiverPackage -> msgRcvrPackage).
					     (#creationFormattedDescription
					      -> (msgRcvrClass name , ' [' , msgRcvrPackage , ']')) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> oldForMessageSends [

	^ self baseQueryForMessageSends collect: [ :row | 
		  | msgRcvrNode msgRcvrClass msgRcvr |
		  msgRcvrNode := row node receiver.
		  msgRcvr := row messageReceiver.

		  msgRcvrClass := msgRcvr class. "msgRcvrNode isVariable
				                     ifTrue: [ 
				                     'a '
				                     ,
				                     (msgRcvrNode variable readInContext:
					                      row context) className ]
				                     ifFalse: [ 
					instMsgReceiver := 
					""msgRcvrNode sourceCode"" ]"
		  New with: { 
				  (#bytecodeIndex -> row bytecodeIndex).
				  (#methodSelector -> row methodSelector).
				  (#receiverClass -> row receiverClass).
				  (#messageArguments -> row node arguments).
				  (#messageReceiver -> msgRcvr).
				  (#formattedMessageReceiver -> (msgRcvrNode isVariable
					    ifTrue: [ 
						    msgRcvrNode variable name , ' ('
						    ,
						    (msgRcvrNode variable readInContext: row context) class
							    asString , ')' ]
					    ifFalse: [ 
						    [ msgRcvr asString , ' (' , msgRcvrNode sourceCode , ')' ] 
							    onErrorDo: [ "msgRcvr" msgRcvrNode sourceCode ] ])).
				  (#messageReceiverClass -> msgRcvrClass value).
				  (#messageSelector -> row node selector) } ]
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> olderForMessageSends [

	| q table |
	table := tracer tables omniscientTableForAliases.

	q := Query
		     from: table
		     select: [ :row | row node isMessage ]
		     collect: [ :row | 
			     | msgRcvrNode msgRcvrClass |
			     msgRcvrNode := row node receiver.
			     msgRcvrClass := msgRcvrNode isVariable
				                     ifTrue: [ 
				                     'a '
				                     ,
				                     (msgRcvrNode variable readInContext:
					                      row context) className ]
				                     ifFalse: [ msgRcvrNode sourceCode ].
			     New with: { 
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#messageArguments -> row node arguments).
					     (#messageReceiverClass -> msgRcvrClass value).
					     (#messageSelector -> row node selector) } ].
	^ q
]
