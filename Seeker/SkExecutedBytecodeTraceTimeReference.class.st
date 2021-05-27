Class {
	#name : #SkExecutedBytecodeTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'executedBytecode'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #'as yet unclassified' }
SkExecutedBytecodeTraceTimeReference >> comparableObject [

	^ executedBytecode
]

{ #category : #'as yet unclassified' }
SkExecutedBytecodeTraceTimeReference >> comparableObjectFromTracer: tracer [

	^ tracer bytecodeIndex
]

{ #category : #accessing }
SkExecutedBytecodeTraceTimeReference >> executedBytecode [

	^ executedBytecode
]

{ #category : #accessing }
SkExecutedBytecodeTraceTimeReference >> executedBytecode: anObject [

	executedBytecode := anObject
]

{ #category : #testing }
SkExecutedBytecodeTraceTimeReference >> referencesTheFuture: tracer [

	^ executedBytecode > tracer bytecodeIndex
]

{ #category : #testing }
SkExecutedBytecodeTraceTimeReference >> referencesThePast: tracer [

	^ executedBytecode < tracer bytecodeIndex
]

{ #category : #testing }
SkExecutedBytecodeTraceTimeReference >> referencesThePresent: tracer [

	^ executedBytecode = tracer bytecodeIndex
]
