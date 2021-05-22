Class {
	#name : #SkXNodeNotation,
	#superclass : #Object,
	#instVars : [
		'statementIndex'
	],
	#category : #'Seeker-Experimental'
}

{ #category : #compiling }
SkXNodeNotation class >> compileSource: aString [

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
SkXNodeNotation >> asSeekerOfflineExpression [

	"Returns an bock that represents a statement. This is used in to denote statements from sequences that doesn't exists"

	| offlineExpressionString |
	offlineExpressionString := self asSeekerOfflineExpressionString.
	^ (self class compileSource: offlineExpressionString) literals at: 1
]

{ #category : #'as yet unclassified' }
SkXNodeNotation >> asSeekerOfflineExpressionString [

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
SkXNodeNotation >> asSeekerStatementExpression [

	"Returns an bock that represents a statement. This is used in to denote statements from sequences that doesn't exists"

	| expressionString |
	expressionString := self asSeekerStatementExpressionString.
	^ (self class compileSource: expressionString) literals at: 1
]

{ #category : #'as yet unclassified' }
SkXNodeNotation >> asSeekerStatementExpressionString [

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
SkXNodeNotation >> asStatementPathNode [

	^ SkXStatementPathNode newFromStatement: self
]

{ #category : #converting }
SkXNodeNotation >> asString [

	^ (sequenceID methodClass name asString), '>>#', (sequenceID selector asString)  , '@' , statementIndex asString
]

{ #category : #'as yet unclassified' }
SkXNodeNotation >> node [
	"We assume for the moment that the sequenceID is a method or block"
	^ sequenceID ast body statements at: statementIndex
]

{ #category : #accessing }
SkXNodeNotation >> sequenceID [
"sequenceID is an expression that could be a CompiledMethod, a CompiledBlock or aBlock"
	^ sequenceID
]

{ #category : #accessing }
SkXNodeNotation >> sequenceID: anObject [

	sequenceID := anObject
]

{ #category : #accessing }
SkXNodeNotation >> statementIndex [

	^ statementIndex
]

{ #category : #accessing }
SkXNodeNotation >> statementIndex: anObject [

	statementIndex := anObject
]
