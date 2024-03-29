Class {
	#name : #SeekerFindContextInStackInterface,
	#superclass : #SeekerInterfaceObject,
	#category : #'Seeker-Interfaces'
}

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> doIt [

	^ SkContextHelpers
		  findContextInStack: [ :aContext | aContext compiledCode isDoIt ]
		  startingContext: tracer currentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> endingContextForDoIt [

	"Returns the context where the test is considered to be finished. However, the context wont be reached, since exiting the DoIt method leaves the execution no longer usable"

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext sender receiver class = SpCodeDebugItInSeekerCommand ]
		  startingContext: tracer currentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> endingContextForMarkedSession [

	"Returns the context where the execution is considered to be finished"

	^ self userStartContextForMarkedSession sender sender
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> endingContextForTestCase [
	"Returns the context where the test is considered to be finished"

	^ SkContextHelpers
		  findContextInStack: [ :aContext |
			  aContext receiver class = TestExecutionEnvironment and: [
				  aContext selector = #runTestCaseUnderWatchdog: and: [
					  aContext compiledCode isCompiledBlock ] ] ]
		  startingContext: tracer currentContext
	"SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext receiver = CurrentExecutionEnvironment and: [ 
				  aContext methodSelector = #runTestCase: and: [ 
					  aContext compiledCode isCompiledMethod ] ] ]
		  startingContext: tracer currentContext" "self recordStartContextForTestCase sender"
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
SeekerFindContextInStackInterface >> recordStartContextForDoIt [

	^ self doIt
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> recordStartContextForMarkedSession [

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext receiver = SeekerSessionHelpers and: [ 
				  aContext methodSelector = #innerSeekerSessionFor:withFlag: ] ]
		  startingContext: tracer slowCurrentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> recordStartContextForPragmaDebugSession [

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext receiver = SeekerSessionHelpers and: [ 
				  aContext methodSelector = #innerSeekerPragmaDebugSessionFor:withFlag: ] ]
		  startingContext: tracer slowCurrentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> recordStartContextForTestCase [

	"Returns the context that seeker Debugger restarts to begin a new replay"

	"^ self endingContextForTestCase sender"

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext receiver = CurrentExecutionEnvironment and: [ 
				  aContext methodSelector = #runTestCase: and: [ 
					  aContext compiledCode isCompiledMethod ] ] ]
		  startingContext: tracer currentContext "SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext methodSelector = #runTestCase: and: [ 
				  aContext compiledCode isCompiledMethod and: [ 
					  aContext receiver class = DefaultExecutionEnvironment ] ] ]
		  startingContext: tracer currentContext"

	"^ self endingContextForTestCase sender"
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> recordStartContextForTestCaseNoSetup [
	"Returns the context that seeker Debugger restarts to begin a new replay"

	"^ self endingContextForTestCase sender"

	^ SkContextHelpers
		  findContextInStack: [ :aContext |
			  aContext receiver = CurrentExecutionEnvironment and: [
				  aContext selector = #runTestCase: and: [
					  aContext compiledCode isCompiledMethod ] ] ]
		  startingContext: tracer currentContext "SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext methodSelector = #runTestCase: and: [ 
				  aContext compiledCode isCompiledMethod and: [ 
					  aContext receiver class = DefaultExecutionEnvironment ] ] ]
		  startingContext: tracer currentContext"

	"^ self endingContextForTestCase sender"
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
SeekerFindContextInStackInterface >> userStartContextForDoIt [

	^ self doIt
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> userStartContextForMarkedSession [

	^ SkContextHelpers
		  findContextInStack: [ :aContext | 
			  aContext receiver = SeekerSessionHelpers and: [ 
				  aContext methodSelector = #seekerSessionStartMaker ] ]
		  startingContext: tracer slowCurrentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> userStartContextForTestCase [

	^ SkContextHelpers
		  findContextInStack: [ :aContext |
			  | senderContext |
			  senderContext := aContext sender.
			  senderContext isNotNil and: [
				  (senderContext receiver class inheritsFrom: TestCase) and: [
					  senderContext selector = #performTest ] ] ]
		  startingContext: tracer currentContext
]

{ #category : #'as yet unclassified' }
SeekerFindContextInStackInterface >> userStartContextForTestCaseNoSetup [

	^ SkContextHelpers
		  findContextInStack: [ :aContext |
			  (aContext receiver class inheritsFrom: TestCase) and: [
				  aContext selector = #performTest ] ]
		  startingContext: tracer currentContext
]
