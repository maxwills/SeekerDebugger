Class {
	#name : #SeekerFindContextInStackInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> endingContextForTestCase [

	"Returns the context where the test is setup and launched"

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			aContext receiver = CurrentExecutionEnvironment  and: [ aContext methodSelector = #runTestCase: and: [ 
				  aContext compiledCode isCompiledMethod ] ]
			   ]
		  startingContext: tracer currentContext
]

{ #category : #accessing }
SeekerFindContextInStackInterface >> nonInlinedOwnerOfNode: aNode startingAt: aContext [

	"searches from top to bottom for the first context that contains said node"

	"we use the = operator for easy implementation. A proper implementation will wisely compare objects idenitity considering that blocknodes exists inside the blockscope and also in the outerscope, but hey have different identity, and that the problem can be somehow manages considering the compiledcode sourceNodeInOuter accessor"

	| ownerNode |
	ownerNode := aNode nonInlinedOwner.
	^ SkContextHelpers
		  findContextInStack: [ :context | 
			  | contextOwnerNode |
			  contextOwnerNode := context nodeForPC nonInlinedOwner.
			  contextOwnerNode = ownerNode ]
		  startingContext: aContext
]

{ #category : #accessing }
SeekerFindContextInStackInterface >> ownerOfNode: aNode startingAt: aContext [

	"searches from top to bottom for the first context that contains said node"

	"we use the = operator for easy implementation. A proper implementation will wisely compare objects idenitity considering that blocknodes exists inside the blockscope and also in the outerscope, but hey have different identity, and that the problem can be somehow manages considering the compiledcode sourceNodeInOuter accessor"

	| ownerNode |
	ownerNode := aNode ownerNode.
	^ SkContextHelpers
		  findContextInStack: [ :context | 
			  | contextOwnerNode |
			  contextOwnerNode := context nodeForPC.
			  contextOwnerNode = ownerNode ]
		  startingContext: aContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> runCaseContextForTestCase [

	"Returns the context where the test is setup and launched"

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			aContext receiver = CurrentExecutionEnvironment  and: [ aContext methodSelector = #runTestCase: and: [ 
				  aContext compiledCode isCompiledMethod ] ]
			   ]
		  startingContext: tracer currentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> userStartContextForTestCase [

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			  | senderContext |
			  senderContext := aContext sender.
			  senderContext isNotNil and: [ 
				  (senderContext receiver class inheritsFrom: TestCase) and: [ 
					  senderContext methodSelector = #performTest ] ] ]
		  startingContext: tracer currentContext
]
