Class {
	#name : #SeekerTraceQueriesInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> baseQuery [

	"returns a query upon the omniscientTable"

	^ Query from: tracer tables omniscientTable
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAliasOfContextReceiverAtStepIndex: aNumber [

	"How to use it
	 |step|
step :=  seeker currentIndexlessStepDescriptor .
(seeker queries forAliasOfContextReceiverWithStepDescriptorPath:step) first"

	| q |
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
	table := tracer tables omniscientTableForAliases.
	q := Query
		     from: table
		     where: [ :row | row node isVariable and: [row node variable name=aVariableNode variable name]]
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

	| table q |
	table := tracer tables omniscientTableForAliases.

	q := Query
		     from: table
		     where: [ :row | row node isAssignment ]
		     select: [ :row | 
			     New with: { 
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#receiverClassAndPackage
					      ->
					      (row receiverClass name, ' [' , row receiverPackage name , ']')).
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#receiverAlias -> row receiverAlias).
					     (#variableNode -> row node variable).
					     (#variableName -> row node variable variable name).
					     (#valueChangedFrom
					      -> (row node variable variable readInContext: row context)).
					     (#valueChangedTo -> (row context at: row context basicSize)).
					     (#receiverPackage -> row receiverPackage).
					     (#variableClass -> row node variable variable class) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forAssignmentsOfInstanceVariables [

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

	| q |
	q := self forInstancesCreation.
	q := Query
		     from: q
		     select: [ :r | 
		     r messageReceiverClass inheritsFromOrSameAs: Exception ]
		     collect: #*.
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forExceptionSignals [

	| q table |
	table := tracer tables omniscientTableForAliases.

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

	| q table |
	table := tracer tables omniscientTableForAliases.

	q := Query
		     from: table
		     select: [ :row | 
			     row nodeIsVariable and: [ 
				     row node variable isInstanceVariable ] ]
		     collect: [ :row | 
			     | variable |
			     variable := row node variable.
			     New with: { 
					     (#stepIndex -> row stepIndex).
					     "(#aliasesDictionary -> row aliasesDictionary)."
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#receiverAlias -> row receiverAlias). "the receiver is the owner of the variable"
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#node -> row node).
					     (#variable -> variable).
					     (#isInstanceVariable -> variable isInstanceVariable).
					     "(#ownerAlias -> (row aliasesDictionary at: row receiver ifAbsent: [nil]))."
					     (#context -> row context) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forInstancesCreation [

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
SeekerTraceQueriesInterface >> forMessageSends [

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

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReceivedMessages [

	| q table |
	table := tracer tables omniscientTableForAliases.

	q := Query
		     from: table
		     select: [ :row | row contextPC = row initialPC ]
		     collect: [ :row | 
			     New with: { 
					     (#bytecodeIndex -> row bytecodeIndex).
					     (#methodSelector -> row methodSelector).
					     (#receiverClass -> row receiverClass).
					     (#arguments -> row context arguments) } ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forReturnValues [

	| q table |
	table := tracer tables omniscientTable.

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
	q := self forReturnValues select: [ :row | 
		     row methodSelector = aSymbol ].
	^ q
]

{ #category : #'as yet unclassified' }
SeekerTraceQueriesInterface >> forVariableValueChanges [

	| q variablesValues |
	variablesValues := self forVariableValues asQueryWithMemory.

	q := Query from: variablesValues select: [:row| row value ~= row previousRow value ] collect: [ :row | 
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
