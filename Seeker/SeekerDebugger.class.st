"
# What is it
Seeker is a time travel debugger extension. It can work with different components that grant different implementation for time travel features.  It doesn't know the ""inside"" of the components, only their interfaces. Because of this, the initialization of components must be done outside (Think of dependency injection). 
The step granularity and graph (execution model) depends directly on the components.

## Pharo Comment

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	stepper:		<Object>


    Implementation Points
"
Class {
	#name : #SeekerDebugger,
	#superclass : #Object,
	#traits : 'TDebuggerUpdateCoordinatorClient',
	#classTraits : 'TDebuggerUpdateCoordinatorClient classTrait',
	#instVars : [
		'stepper',
		'stDebugger',
		'sindarin'
	],
	#category : #'Seeker-Core'
}

{ #category : #'instance creation' }
SeekerDebugger class >> newWithStatementGranularity: aStDebugger sindarin: aSindarinDebugger [

	"Initializes a seeker debugger with a statement-level stepper and trace.
    Returns a SeekerDebugger"

	| debugger stepper updateCoordinator |
	updateCoordinator := DebuggerUpdateCoordinator new. "The coordinator is owned by the presenter"
	updateCoordinator stDebugger: aStDebugger.
	
	"Initialize the DebuggerStepperBase subclass to be injected in the seeker debugger"
	stepper := DSStatementTracer new.
	stepper stDebugger: aStDebugger.
	stepper sindarin: aSindarinDebugger.
	stepper debuggerUpdateCoordinator: updateCoordinator.

	debugger := SeekerDebugger new.
	debugger initializeWithStepper: stepper.
	debugger stDebugger: aStDebugger.
	debugger sindarin: aSindarinDebugger.
	debugger debuggerUpdateCoordinator: updateCoordinator.

	^ debugger
]

{ #category : #accessing }
SeekerDebugger >> currentStepDescriptor [
	^ stepper currentStepDescriptor
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> evaluateExpression: aString inContext: aContext [
   "Evaluates the expression coming from a stream. Uses the current context of the StDebugger"
   ^ aContext receiver class compiler
        source: aString;
        context: aContext;
        receiver: aContext receiver;
        requestor: self;
        failBlock: [ nil ];
        evaluate
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> evaluateExpression: aString inContext: aContext throws: anError [
   "Evaluates the expression coming from a stream. Uses the current context of the StDebugger"
   [  aContext receiver class compiler
        source: aString;
        context: aContext;
        receiver: aContext receiver;
        requestor: self;
        failBlock: [ nil ];
        evaluate] on: anError do: [ :e| ^true ] . ^false
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> getContextOfStep: aNumber [
	^ (stepper trace at: aNumber) context
]

{ #category : #initialization }
SeekerDebugger >> initialize [
^super initialize 
]

{ #category : #initialization }
SeekerDebugger >> initializeWithStepper: aDebuggerStepper [
	stepper := aDebuggerStepper
]

{ #category : #testing }
SeekerDebugger >> isExecutionFinished [

	^ stepper isExecutionFinished
]

{ #category : #printing }
SeekerDebugger >> printTrace [
	Transcript show: stepper trace asString
]

{ #category : #starting }
SeekerDebugger >> restart [
	"restarts execution form selected context"	
		stepper restart
]

{ #category : #starting }
SeekerDebugger >> restartFromContext: aContext [
	"restarts execution form selected context"	
		stDebugger session restart: aContext
]

{ #category : #initialization }
SeekerDebugger >> setEndFromCurrentStep [
stepper setEndFromCurrentStep
]

{ #category : #initialization }
SeekerDebugger >> setSelectedContextAsStartingPoint: aContext [
	stepper setSelectedContextAsStartingPoint: aContext
]

{ #category : #accessing }
SeekerDebugger >> sindarin [

	^ sindarin
]

{ #category : #accessing }
SeekerDebugger >> sindarin: anObject [

	sindarin := anObject
]

{ #category : #accessing }
SeekerDebugger >> stDebugger [

	^ stDebugger
]

{ #category : #accessing }
SeekerDebugger >> stDebugger: anObject [

	stDebugger := anObject
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> startRecordFromContext: aContext [
	stepper restartRecordFromContext: aContext
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepBackInto [
	stepper stepBackInto.
	Transcript clear.
	self printTrace
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepBackOver [
	stepper stepBackOver.
	Transcript clear.
	self printTrace
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepInto [

	stepper stepInto.
	Transcript clear.
	self printTrace
]

{ #category : #'debug - stepping' }
SeekerDebugger >> stepOver [
	stepper stepOver.
	Transcript clear.
	self printTrace
]

{ #category : #'as yet unclassified' }
SeekerDebugger >> stepUntilConditionIsTrue: aBlock [
	stepper stepUntilConditionIsTrue: aBlock
]

{ #category : #accessing }
SeekerDebugger >> stepper [

	^ stepper
]
