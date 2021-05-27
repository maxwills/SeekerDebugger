Class {
	#name : #SkTracedInstructionTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'tracedInstructionPC'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #testing }
SkTracedInstructionTraceTimeReference >> referencesTheFuture: tracer [

	^ self error: 'to be implemented'
]

{ #category : #testing }
SkTracedInstructionTraceTimeReference >> referencesTheLocalFuture: tracer [

	"Is this trace time a reference to the future in the same sequence?"

	| context |
	context := tracer currentContext.
	^ (context matchesTracedContextPC:
		   tracedInstructionPC tracedContextPC) and: [ 
		  context pc < tracedInstructionPC pc ]
]

{ #category : #testing }
SkTracedInstructionTraceTimeReference >> referencesTheLocalPast: tracer [

	"Is this trace time a reference to the past in the same sequence?"

	| context |
	context := tracer currentContext.
	^ (context matchesTracedContextPC:
		   tracedInstructionPC tracedContextPC) and: [ 
		  context pc > tracedInstructionPC pc ]
]

{ #category : #testing }
SkTracedInstructionTraceTimeReference >> referencesThePast: tracer [

	^ self error: 'to be implemented'
]

{ #category : #testing }
SkTracedInstructionTraceTimeReference >> referencesThePresent: tracer [

	^ tracer currentContext matchesTracedInstructionPC:
		  tracedInstructionPC
]

{ #category : #accessing }
SkTracedInstructionTraceTimeReference >> tracedInstructionPC [

	^ tracedInstructionPC
]

{ #category : #accessing }
SkTracedInstructionTraceTimeReference >> tracedInstructionPC: anObject [

	tracedInstructionPC := anObject
]
