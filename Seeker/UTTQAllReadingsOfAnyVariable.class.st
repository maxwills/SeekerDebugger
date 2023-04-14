Class {
	#name : #UTTQAllReadingsOfAnyVariable,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'instance creation' }
UTTQAllReadingsOfAnyVariable class >> queryFrom: programStates [

	^ self
		  from: programStates
		  select: [ :state |
			  state isVariable or: [ state isImplicitReadingOfInstanceVariable ] ]
		  collectAs: [ :state :res |
			  | isImplicit node varName val varCls |
			  isImplicit := state isImplicitReadingOfInstanceVariable
				                forceTrueOrFalse.
			  node := isImplicit
				          ifTrue: [ state node ]
				          ifFalse: [ state node parent ].
			  varName := isImplicit
				             ifTrue: [ state nameOfImplicitReadInstanceVariable ]
				             ifFalse: [ state node variable name ].
			  varCls := isImplicit
				            ifTrue: [ state implicitReadInstanceVariable class ]
				            ifFalse: [ state node variable class ].
				val := isImplicit
				             ifTrue: [ state valueOfImplicitReadInstanceVariable ]
				             ifFalse: [ state variableValue].
				res
				  bytecodeIndex: state bytecodeIndex;
				  varClass: varCls;
				  variableName: varName;
				  value: val;
				  source: node sourceCode;
				  implicitRead: isImplicit;
				  inNode: node ]
]

{ #category : #'as yet unclassified' }
UTTQAllReadingsOfAnyVariable >> ttqTitle [

	^ 'Find All Readings of Any Variable'
]
