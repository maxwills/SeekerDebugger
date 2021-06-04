Extension { #name : #Object }

{ #category : #'*Seeker' }
Object >> ! anObject [

	"self flag remember to remove this"

	self value: anObject
]

{ #category : #'*Seeker' }
Object >> ? aBlock [

	"self flag remember to remove this"

	aBlock value: self
]

{ #category : #'*Seeker' }
Object >> @< another [

	^ self < another
]

{ #category : #'*Seeker' }
Object >> @<= another [

	^ self <= another
]

{ #category : #'*Seeker' }
Object >> @= another [

	^ self = another
]

{ #category : #'*Seeker' }
Object >> @> another [

	^ self > another
]

{ #category : #'*Seeker' }
Object >> @>= another [

	^ self >= another
]

{ #category : #'*Seeker' }
Object >> asScopedObjectDo: aBlock [

	aBlock argumentCount ~= 1 ifTrue: [ 
		^ self error: 'The number of arguments of the block must be one' ].
	[ aBlock value: self ] ensure: [ self finalize ]
]

{ #category : #'*Seeker' }
Object class >> atSeekerAuxStorage1 [

	^ SeekerGlobals instance auxiliaryTempStorage1
]

{ #category : #'*Seeker' }
Object class >> atSeekerAuxStorage2 [

	^ SeekerGlobals instance auxiliaryTempStorage2
]

{ #category : #'*Seeker' }
Object >> defaultSeekerCacheObjectClass [

	^ SeekerCacheObject
]

{ #category : #'*Seeker' }
Object >> putInSeekerAuxStorage1 [
	SeekerGlobals instance auxiliaryTempStorage1: self
]

{ #category : #'*Seeker' }
Object >> putInSeekerAuxStorage2 [
	SeekerGlobals instance auxiliaryTempStorage2: self
]

{ #category : #'*Seeker' }
Object >> seekAllChangesOnSelf [
	

]

{ #category : #'*Seeker' }
Object >> seekAllMyChanges [

	| seeker |
	seeker := self seekMe.
	seeker ifNotNil: [ 
		^ (seeker find changesOfObject: self) asSeekerResultsCollection
			  forAssignmentsOfInstanceVariables ].
	^ nil
]

{ #category : #'*Seeker' }
Object >> seekAndDisplayAllMyChanges [

	| results seeker |
	seeker := self seekMe.
	results := self seekAllMyChanges.
	results
		ifNotNil: [ 
			seeker seekerResultsPresenter showResult: results.
			self inform: 'Results being shown in Results table' ]
		ifNil: [ self error: 'Could not execute query' ]
]

{ #category : #'*Seeker' }
Object >> seekMe [

	SeekerDebugger allInstances.
	SeekerDebugger allInstances reverseDo: [ :s | 
		((s tracer isNotNil and: [ s tracer isSessionActive isNotNil ]) 
			 and: [ s tracer isSessionActive ]) ifTrue: [ 
			| alias |
			alias := s tracer readAliasOf: self.
			alias ifNotNil: [ ^ s tracer ] ] ].
	^ nil
]

{ #category : #'*Seeker' }
Object >> seekMyAlias [

	SeekerDebugger allInstances.
	SeekerDebugger allInstances reverseDo: [ :s | 
		s tracer isSessionActive ifTrue: [ 
			| alias |
			alias := s tracer readAliasOf: self.
			alias ifNotNil: [ ^ alias ] ] ].
	^ nil
]

{ #category : #'*Seeker' }
Object >> seekerCache [

	^ SeekerCache seekerCacheObjectOf: self
]
