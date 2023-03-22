Class {
	#name : #QuerySolver,
	#superclass : #Object,
	#instVars : [
		'query',
		'resultsLimit',
		'timeToRun',
		'initialTime'
	],
	#classVars : [
		'IncludeInstrumentation',
		'IncludeSystemClasses',
		'PotentiallyExcludedSeekerClasses',
		'PotentiallyExcludedSystemClasses'
	],
	#category : #'Seeker-Query'
}

{ #category : #'as yet unclassified' }
QuerySolver class >> disableIncludeInstrumentation [

	<script>
	IncludeInstrumentation := false
]

{ #category : #'as yet unclassified' }
QuerySolver class >> disableIncludeSystemClasses [

	<script>
	IncludeSystemClasses := false
]

{ #category : #'as yet unclassified' }
QuerySolver class >> enableIncludeInstrumentation [

	<script>
	IncludeInstrumentation := true
]

{ #category : #'as yet unclassified' }
QuerySolver class >> enableSystemClasses [

	<script>
	IncludeSystemClasses := true
]

{ #category : #'as yet unclassified' }
QuerySolver class >> includeInstrumentation [

	^ IncludeInstrumentation
]

{ #category : #'as yet unclassified' }
QuerySolver class >> includeInstrumentation: anObject [

	IncludeInstrumentation := anObject
]

{ #category : #'as yet unclassified' }
QuerySolver class >> includeSystemClasses [

	^ IncludeSystemClasses
]

{ #category : #'as yet unclassified' }
QuerySolver class >> includeSystemClasses: anObject [

	IncludeSystemClasses := anObject
]

{ #category : #initialization }
QuerySolver class >> initialize [

	IncludeInstrumentation := true.
	IncludeSystemClasses := true.
	PotentiallyExcludedSeekerClasses := IdentitySet new.
	PotentiallyExcludedSeekerClasses addAll:
		(RPackageOrganizer default packageNamed: #Seeker) definedClasses.
	PotentiallyExcludedSeekerClasses addAll:
		(RPackageOrganizer default packageNamed: #QuickWrap) definedClasses.
	"UnifiedFFI"

	PotentiallyExcludedSystemClasses := IdentitySet new.
	PotentiallyExcludedSystemClasses addAll: { 
			Point.
			String.
			ByteSymbol.
			SmallFloat64.
			Float.
			Array.
			SortedCollection.
			WriteStream.
			Collection.
			OrderedCollection.
			Set.
			MethodDictionary.
			CompiledMethod.
			Rectangle.
			Number.
			String.
			Stream.

			ByteString.
			SmallInteger.
			Boolean }
]

{ #category : #'instance creation' }
QuerySolver class >> newForQuery: aQuery [

	^ self new
		  query: aQuery;
		  yourself
]

{ #category : #'as yet unclassified' }
QuerySolver class >> otherExcludedClases [

	^ PotentiallyExcludedSystemClasses
]

{ #category : #'as yet unclassified' }
QuerySolver class >> seekerInstrumentationClasses [

	^ PotentiallyExcludedSeekerClasses
]

{ #category : #'instance creation' }
QuerySolver class >> solve: aQuery [

	^ (self newForQuery: aQuery) resolve
]

{ #category : #'as yet unclassified' }
QuerySolver >> ellapsedTime [

	^  Time millisecondClockValue - initialTime - Smalltalk vm totalGCTime
]

{ #category : #initialization }
QuerySolver >> initialize [

	resultsLimit := self seekerConfig queryResultsLimitEnabled
		                ifTrue: [ self seekerConfig queryResultsLimit ]
		                ifFalse: [ 9999999 "a big number" ].
	timeToRun := 0
]

{ #category : #'as yet unclassified' }
QuerySolver >> notifyResultsLimitReached [

	^ self inform:
		  'Query results limit reached: ' , resultsLimit asString
]

{ #category : #accessing }
QuerySolver >> query [

	^ query
]

{ #category : #accessing }
QuerySolver >> query: anObject [

	query := anObject
]

{ #category : #'as yet unclassified' }
QuerySolver >> queryToSolve [

	"Filters a query, leaving out instrumented code and other undesirable result items. Might be reworked with the new stepping pipeline"

	| excluded |
	query isNotExecutionQuery ifTrue: [ ^ query ].
	(IncludeInstrumentation and: [ IncludeSystemClasses ]) ifTrue: [ 
		^ query ].

	excluded := IdentitySet new.
	IncludeInstrumentation ifFalse: [ 
		excluded addAll: PotentiallyExcludedSeekerClasses ].
	IncludeSystemClasses ifFalse: [ 
		excluded addAll: PotentiallyExcludedSystemClasses ].

	^ query select: [ :state | 
		  | receiver |
		  receiver := state receiver.
		  receiver isClass
			  ifTrue: [ (excluded includes: state receiver) not ]
			  ifFalse: [ (excluded includes: state receiver class) not ] ]
]

{ #category : #navigating }
QuerySolver >> resolve [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
QuerySolver >> seekerConfig [

	^ SeekerConfig default
]

{ #category : #initialization }
QuerySolver >> setInitialTime [

	initialTime := Time millisecondClockValue - Smalltalk vm totalGCTime
]

{ #category : #accessing }
QuerySolver >> timeToRun [

	^ timeToRun
]
