Class {
	#name : #SkXNodeInCompiledCode,
	#superclass : #Object,
	#instVars : [
		'compiledCode',
		'nodeIndex'
	],
	#category : #'Seeker-Experimental-NodeNotation'
}

{ #category : #converting }
SkXNodeInCompiledCode >> asNicPath [

	^ SkXNodeInCompiledCodePath new / self
]

{ #category : #accessing }
SkXNodeInCompiledCode >> compiledCode [

	^ compiledCode
]

{ #category : #accessing }
SkXNodeInCompiledCode >> compiledCode: anObject [

	compiledCode := anObject
]

{ #category : #converting }
SkXNodeInCompiledCode >> fullNicPath [

	"Creates the nic path for the node compiledcode and every outerCode, up to the compiledMethod (included)"

	^ self parentFullNicPath / self
]

{ #category : #accessing }
SkXNodeInCompiledCode >> node [

	"Resolves the node"

	^ compiledCode @ nodeIndex
]

{ #category : #accessing }
SkXNodeInCompiledCode >> nodeIndex [

	^ nodeIndex
]

{ #category : #accessing }
SkXNodeInCompiledCode >> nodeIndex: anObject [

	nodeIndex := anObject
]

{ #category : #'as yet unclassified' }
SkXNodeInCompiledCode >> parentFullNicPath [

	"Used recursively to create the full NIC path"

	| parentNic |
	parentNic := self parentNic.
	^ parentNic
		  ifNil: [ 
			  SkXNodeInCompiledCodePath new "CompiledMethod os the top node, and have no parent" ]
		  ifNotNil: [ parentNic fullNicPath ]
]

{ #category : #'as yet unclassified' }
SkXNodeInCompiledCode >> parentNic [

	"Used recursively to create the full NIC path"

	^ compiledCode isCompiledMethod
		  ifTrue: [ 
		  nil "CompiledMethod is the top node, and have no parent" ]
		  ifFalse: [ 
			  | ccOfParent parentNode parentNic |
			  ccOfParent := compiledCode outerCode.
			  parentNode := compiledCode sourceNode.
			  parentNic := self class new.
			  parentNic nodeIndex: parentNode ordinalIndex.
			  parentNic compiledCode: ccOfParent.

			  parentNic ]
]
