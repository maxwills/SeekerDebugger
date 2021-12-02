Class {
	#name : #SkNodeTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'node',
		'ownerNode',
		'nodeStop',
		'nodeStart',
		'ownerStop'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #accessing }
SkNodeTraceTimeReference >> node [

	^ node
]

{ #category : #accessing }
SkNodeTraceTimeReference >> node: anObject [

	node := anObject.
	ownerNode := node ownerNode.
	nodeStop := node stop.
	ownerStop := ownerNode stop.
	nodeStart := node start
]

{ #category : #testing }
SkNodeTraceTimeReference >> referencesTheLocalPast: tracer [

	| currentNode currentStop |
	currentNode := tracer currentStateInterface node.
	currentStop := currentNode stop.
	^ currentNode ownerNode = ownerNode and: [ 
		  node ~= currentNode and: [ 
			  nodeStop <= currentStop and: [ currentNode start <= nodeStart ] ] ]
]

{ #category : #testing }
SkNodeTraceTimeReference >> referencesTheLocalPastOrPresent: tracer [

	| currentNode currentStop |
	"Should use nonInlinedOwnerInstead?"
	currentNode := tracer currentStateInterface node.
	currentStop := currentNode stop.
	currentNode ownerNode = ownerNode ifFalse: [ ^ false ].
	^ currentNode isMethod
		  ifTrue: [ 
		  nodeStop == currentStop and: [ currentNode start == nodeStart ] ]
		  ifFalse: [ 
		  nodeStop <= currentStop and: [ currentNode start <= nodeStart ] ]
]

{ #category : #testing }
SkNodeTraceTimeReference >> referencesThePresent: tracer [

	^ tracer currentStateInterface node = node
]
