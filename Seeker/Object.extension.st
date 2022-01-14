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
Object >> asyncSend [

	^ TaskBuilder newForReceiver: self
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
Object >> defaultCase: aValuable [

	"used for switch case do"

	^ self
]

{ #category : #'*Seeker' }
Object >> defaultSeekerCacheObjectClass [

	^ SeekerCacheObject
]

{ #category : #'*Seeker' }
Object >> doCases [

	| switchBlock |
	^ switchBlock := [ :caseBlock :doBlock | 
	                 | caseVal |
	                 caseVal := caseBlock value.
	                 (#performDefaultCase == caseVal or: [ 
		                  self value = caseVal ])
		                 ifTrue: [ 
			                 doBlock value.
			                 switchBlock ]
		                 ifFalse: [ switchBlock ] ]
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
Object >> seekAllMessagesSentToMe [

	| seeker |
	seeker := self seekMe.
	seeker ifNotNil: [ 
		| oid res |
		oid := self seekMyOid.
		res := (TTQAllMessagesSentToObject
			        queryFrom: seeker newProgramStates
			        withObjectOid: oid) asCollection.
		^ res ].
	^ nil
]

{ #category : #'*Seeker' }
Object >> seekAllMyChanges [

	| seeker |
	seeker := self seekMe.
	seeker ifNotNil: [ 
		| oid res |
		oid := self seekMyOid.
		res := (TTQAllAssignmentsOfInstanceVariablesOfObject
			        queryFrom: seeker newProgramStates
			        withObjectOid: oid) asCollection.
		^ res ].

	^ nil
]

{ #category : #'*Seeker' }
Object >> seekAndDisplayAllMessagesSentToMe [

	| seeker error |
	error := true.

	[ 
	seeker := self seekMe.
	seeker ifNotNil: [ 
		| oid |
		oid := self seekMyOid.
		oid ifNil: [ ^ self error: 'Seeker: obtained Oid was nil.' ].
		seeker ui showInResult: (TTQAllMessagesSentToObject
				 queryFrom: seeker newProgramStates
				 withObjectOid: oid) displayModel.
		error := false ] ] ensure: [ 
		error
			ifFalse: [ self inform: 'Results being shown in results table' ]
			ifTrue: [ self error: 'Could not execute query' ] ]
]

{ #category : #'*Seeker' }
Object >> seekAndDisplayAllMyChanges [

	| seeker error |
	error := true.

	[ 
	seeker := self seekMe.
	seeker ifNotNil: [ 
		| oid |
		oid := self seekMyOid.
		oid ifNil: [ ^ self error: 'Seeker: obtained Oid was nil.' ].
		seeker ui showInResult:
			(TTQAllAssignmentsOfInstanceVariablesOfObject
				 queryFrom: seeker newProgramStates
				 withObjectOid: oid) displayModel.
		error := false ] ] ensure: [ 
		error
			ifFalse: [ self inform: 'Results being shown in tesults table' ]
			ifTrue: [ self error: 'Could not execute query' ] ]
]

{ #category : #'*Seeker' }
Object >> seekMe [

	SeekerDebugger allInstances.
	SeekerDebugger allInstances reverseDo: [ :s | 
		((s tracer isNotNil and: [ s tracer isSessionActive isNotNil ]) 
			 and: [ s tracer isSessionActive ]) ifTrue: [ 
			| alias |
			alias := s tracer getOidOf: self.
			alias ifNotNil: [ ^ s tracer ] ] ].
	^ nil
]

{ #category : #'*Seeker' }
Object >> seekMyInspectors [

	^ StInspector allInstances select: [ :insp | 
		  insp model inspectedObject == self ]
]

{ #category : #'*Seeker' }
Object >> seekMyOid [

	SeekerDebugger allInstances.
	SeekerDebugger allInstances reverseDo: [ :s | 
		s tracer isSessionActive ifTrue: [ 
			| alias |
			alias := s tracer getOidOf: self.
			alias ifNotNil: [ ^ alias ] ] ].
	^ nil
]

{ #category : #'*Seeker' }
Object >> seekerCache [

	^ SeekerCache seekerCacheObjectOf: self
]
