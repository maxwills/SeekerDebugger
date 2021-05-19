Class {
	#name : #SkXStatementNotation,
	#superclass : #Object,
	#instVars : [
		'sequenceID',
		'statementIndex'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #compiling }
SkXStatementNotation class >> compileSource: aString [

	^ nil class compiler
		  source: aString;
		  class: nil;
		  context: nil;
		  requestor: nil;
		  "it should enable a visibility of current tool variables in new debugger"
		  noPattern: true;
		  failBlock: [ ^ nil ];
		  compile
]

{ #category : #'as yet unclassified' }
SkXStatementNotation >> asSeekerOfflineExpression [

	"Returns an bock that represents a statement. This is used in to denote statements from sequences that doesn't exists"

	| offlineExpressionString |
	offlineExpressionString := self asSeekerOfflineExpressionString.
	^ (self class compileSource: offlineExpressionString) literals at: 1
]

{ #category : #'as yet unclassified' }
SkXStatementNotation >> asSeekerOfflineExpressionString [

	"Returns an bock that represents a statement. This is used in to denote statements from sequences that doesn't exists"

	| seqClassSymbol seqMethodSymbol stringExpression |
	seqClassSymbol := sequenceID methodClass name asSymbol.
	seqMethodSymbol := sequenceID selector.
	stringExpression := '[#' , seqClassSymbol asString , '>>#'
	                    , seqMethodSymbol asString , '@'
	                    , statementIndex asString , ']'.
	^ stringExpression
]

{ #category : #'as yet unclassified' }
SkXStatementNotation >> asSeekerStatementExpression [

	"Returns an bock that represents a statement. This is used in to denote statements from sequences that doesn't exists"

	| expressionString |
	expressionString := self asSeekerStatementExpressionString.
	^ (self class compileSource: expressionString) literals at: 1
]

{ #category : #'as yet unclassified' }
SkXStatementNotation >> asSeekerStatementExpressionString [

	"Returns an bock that represents a statement. This is used in to denote statements from sequences that doesn't exists"

	| seqClassSymbol seqMethodSymbol stringExpression |
	seqClassSymbol := sequenceID methodClass name asSymbol.
	seqMethodSymbol := sequenceID selector.
	stringExpression := '[' , seqClassSymbol asString , '>>#'
	                    , seqMethodSymbol asString , '@'
	                    , statementIndex asString , ']'.
	^ stringExpression
]

{ #category : #converting }
SkXStatementNotation >> asStatementPathNode [

	^ SkXStatementPathNode newFromStatement: self
]

{ #category : #converting }
SkXStatementNotation >> asString [

	^ (sequenceID methodClass name asString), '>>#', (sequenceID selector asString)  , '@' , statementIndex asString
]

{ #category : #'as yet unclassified' }
SkXStatementNotation >> node [
	"We assume for the moment that the sequenceID is a method or block"
	^ sequenceID ast body statements at: statementIndex
]

{ #category : #accessing }
SkXStatementNotation >> sequenceID [
"sequenceID is an expression that could be a CompiledMethod, a CompiledBlock or aBlock"
	^ sequenceID
]

{ #category : #accessing }
SkXStatementNotation >> sequenceID: anObject [

	sequenceID := anObject
]

{ #category : #accessing }
SkXStatementNotation >> statementIndex [

	^ statementIndex
]

{ #category : #accessing }
SkXStatementNotation >> statementIndex: anObject [

	statementIndex := anObject
]
