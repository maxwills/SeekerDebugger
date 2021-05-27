"
A trace time reference that represents the current trace time. It's always present, and always not in past or future. Only useful for comparison by using <,>, = operators.
"
Class {
	#name : #SkCurrentTraceTimeReference,
	#superclass : #SkTraceTimeReference,
	#instVars : [
		'tracer'
	],
	#category : #'Seeker-TraceTime'
}

{ #category : #comparing }
SkCurrentTraceTimeReference >> @< anotherTraceTime [

	^ anotherTraceTime @> self
]

{ #category : #comparing }
SkCurrentTraceTimeReference >> @<= anotherTraceTime [

	^ anotherTraceTime @>= self
]

{ #category : #comparing }
SkCurrentTraceTimeReference >> @= anotherTraceTime [

	^ anotherTraceTime @= self
]

{ #category : #comparing }
SkCurrentTraceTimeReference >> @> anotherTraceTime [

	^ anotherTraceTime @< self
]

{ #category : #comparing }
SkCurrentTraceTimeReference >> @>= anotherTraceTime [

	^ anotherTraceTime @<= self
]

{ #category : #testing }
SkCurrentTraceTimeReference >> isOfCurrentTraceTimeClass [

	^ true
]

{ #category : #testing }
SkCurrentTraceTimeReference >> referencesTheFuture: atracer [

	"Does this trace time reference the future?"

	^ false
]

{ #category : #testing }
SkCurrentTraceTimeReference >> referencesTheLocalFuture: atracer [

	"Answer if the current trace time is in the same traced context as the one denoted by self"

	"For contexts, local future and local pasts are the same as present"

	^ false
]

{ #category : #testing }
SkCurrentTraceTimeReference >> referencesTheLocalPast: atracer [

	"Answer if the current trace time is in the same traced context as the one denoted by self"

	"For contexts, local future and local pasts are the same as present"

	^ false
]

{ #category : #testing }
SkCurrentTraceTimeReference >> referencesThePast: atracer [

	"Does this trace time reference the past ?"

	^ false
]

{ #category : #testing }
SkCurrentTraceTimeReference >> referencesThePresent: atracer [

	"Does this trace time reference the present?"

	^ true
]

{ #category : #accessing }
SkCurrentTraceTimeReference >> tracer [

	^ tracer
]

{ #category : #accessing }
SkCurrentTraceTimeReference >> tracer: anObject [

	tracer := anObject
]
