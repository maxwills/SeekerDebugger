Class {
	#name : #SkTracedContextTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'tracedContextPC'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #'as yet unclassified' }
SkTracedContextTraceTimeReference >> comparableObject [

	^ tracedContextPC
]

{ #category : #'as yet unclassified' }
SkTracedContextTraceTimeReference >> comparableObjectFromTracer: tracer [

	^ tracer currentContext tracedContextPC
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesTheFuture: tracer [

	^ tracedContextPC @> tracer currentContext tracedContextPC
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
SkTracedContextTraceTimeReference >> referencesTheLocalPastOrPresent: tracer [

	^ self referencesThePresent: tracer
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesThePast: tracer [

	^ tracedContextPC @< tracer currentContext tracedContextPC
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesThePresent: tracer [

	^ tracer currentContext matchesTracedContextPC: tracedContextPC
]

{ #category : #testing }
SkTracedContextTraceTimeReference >> referencesThePresentOrLocalFuture: tracer [

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
