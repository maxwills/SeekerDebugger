Class {
	#name : #EvaluatorDebuggerCodeInteractionModel,
	#superclass : #SpCodeScriptingInteractionModel,
	#instVars : [
		'context'
	],
	#category : #'EvaluatorDebugger-Base'
}

{ #category : #binding }
EvaluatorDebuggerCodeInteractionModel >> bindingOf: aString [
   ^ (context lookupVar: aString) ifNotNil: [ :var | 
        var asDoItVariableFrom: context ]
]

{ #category : #accessing }
EvaluatorDebuggerCodeInteractionModel >> context [
   ^ context
 
]

{ #category : #accessing }
EvaluatorDebuggerCodeInteractionModel >> context: anObject [
   context := anObject
]

{ #category : #accessing }
EvaluatorDebuggerCodeInteractionModel >> hasBindingOf: aString [
   ^ (context lookupVar: aString) notNil
]
