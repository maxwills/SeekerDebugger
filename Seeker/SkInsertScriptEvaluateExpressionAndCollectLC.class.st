Class {
	#name : #SkInsertScriptEvaluateExpressionAndCollectLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkInsertScriptEvaluateExpressionAndCollectLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkInsertScriptEvaluateExpressionAndCollectLC >> executeCommand [

	"Needs a mapped execution"
	self seekerDebuggerPresenter insertCodeText:
		'seeker stepper replayWhileEvaluatingExpressionInTheFirstStepOfEveryContextAndCollectResult: YOUREXPRESSIONASASTRING', String cr
]

{ #category : #accessing }
SkInsertScriptEvaluateExpressionAndCollectLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkInsertScriptEvaluateExpressionAndCollectLC >> name [

	^'Insert script to evaluate an expression in each context and collect the result'
]
