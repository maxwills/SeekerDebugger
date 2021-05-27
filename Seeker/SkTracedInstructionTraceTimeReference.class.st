Class {
	#name : #SkTracedInstructionTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'tracedInstructionPC'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #'as yet unclassified' }
SkTracedInstructionTraceTimeReference >> comparableObject [

	^ tracedInstructionPC
]

{ #category : #'as yet unclassified' }
SkTracedInstructionTraceTimeReference >> comparableObjectFromTracer: tracer [

	^ tracer currentContext tracedInstructionPC
]

{ #category : #testing }
SkTracedInstructionTraceTimeReference >> referencesTheFuture: tracer [

	^ tracedInstructionPC > tracer currentContext tracedInstructionPC
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

	^ tracedInstructionPC < tracer currentContext tracedInstructionPC
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
