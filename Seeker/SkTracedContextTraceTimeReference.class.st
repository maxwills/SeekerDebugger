Class {
	#name : #SkTracedContextTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'tracedContextPC'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesTheFuture: tracer [

	^ self error: 'to be implemented'
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesTheLocalFuture: tracer [

	^ self referencesThePresent: tracer
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesTheLocalPast: tracer [

	^ self referencesThePresent: tracer
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesThePast: tracer [

	^ self error: 'to be implemented'
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesThePresent: tracer [

	^ tracer currentContext matchesTracedContextPC: tracedContextPC
]

{ #category : #accessing }
SkTracedContextTraceTimeReference >> tracedContextPC [

	^ tracedContextPC
]

{ #category : #accessing }
SkTracedContextTraceTimeReference >> tracedContextPC: anObject [

	tracedContextPC := anObject
]
