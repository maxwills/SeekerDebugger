Class {
	#name : #SkExecutionRestorer,
	#superclass : #SkComponent,
	#instVars : [
		'tracer',
		'preventNextTimeRestoration'
	],
	#category : #'Seeker-Tracing'
}

{ #category : #accessing }
SkExecutionRestorer >> checkPreventNextTimeRestoration [

	"Used to prevent restorting the live session when a query is manually stopped (Why? because it is useful to know where the execution is at the moment of the emergency stop"

	| val |
	val := preventNextTimeRestoration.
	preventNextTimeRestoration := false.
	^ val
]

{ #category : #accessing }
SkExecutionRestorer >> initialize [

	preventNextTimeRestoration := false
]

{ #category : #accessing }
SkExecutionRestorer >> preventNextTimeRestoration [

	^ preventNextTimeRestoration
]

{ #category : #accessing }
SkExecutionRestorer >> preventNextTimeRestoration: anObject [

	preventNextTimeRestoration := anObject
]

{ #category : #accessing }
SkExecutionRestorer >> tracer [

	^ tracer
]

{ #category : #accessing }
SkExecutionRestorer >> tracer: anObject [

	tracer := anObject
]
