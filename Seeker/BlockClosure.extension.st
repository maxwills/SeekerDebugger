Extension { #name : #BlockClosure }

{ #category : #'*Seeker' }
BlockClosure >> asReversibleDo: aBlock [
	"example"

	| reversibleExecution |
	reversibleExecution := (SeekerDebugger headlessDebugBlock: self)
		                       stepToEnd;
		                       yourself.
	[ aBlock value: reversibleExecution ] ensure: [
		reversibleExecution terminate ]
]

{ #category : #'*Seeker' }
BlockClosure >> case: caseBlock do: doBlock [

	^ self value: caseBlock value: doBlock
]

{ #category : #'*Seeker' }
BlockClosure >> defaultCase: aValuable [

	"used for switch case do"

	^ self value: #performDefaultCase value: aValuable
]

{ #category : #'*Seeker' }
BlockClosure >> lockUntilTrue [

	^ self whileFalse: [ "busy wait" true ]
]

{ #category : #'*Seeker' }
BlockClosure >> programQuery [
"Experimental feature"
	^ SeekerQueryInterface newForBlock: self
]

{ #category : #'*Seeker' }
BlockClosure >> programQuery: queriesBlock [
	"Experimental feature"

	| sqi |
	sqi := SeekerQueryInterface newForBlock: self.
	[ queriesBlock value: sqi ] ensure: [ sqi terminate ]
]

{ #category : #'*Seeker' }
BlockClosure >> programStates [
	"experimental feature"

	^ (SeekerDebugger headlessDebugBlock: self) tracer newProgramStates
]

{ #category : #'*Seeker' }
BlockClosure >> programStates: block [
	"experimental feature. cleaner notation"

	| sk |
	sk := SeekerDebugger headlessDebugBlock: self.
	[ block value: sk tracer newProgramStates ] ensure: [ sk terminate ]
]

{ #category : #'*Seeker' }
BlockClosure >> reversibleValue [
	"experimental feature. Quite slow"

	^ (SeekerDebugger headlessDebugBlock: self)
		  stepToEnd;
		  yourself
]

{ #category : #'*Seeker' }
BlockClosure >> switchCase: anArrayOfCases [

	"A case is a pair where the first item is the key for the case and the value is a block to be executed if the result of self value matches the key value. if the result of the evaluation of self is not found in the keys values, it will execute the #defaultCase keyed case from the list. Throws and error if no case was matched"

	"Why linear seach instead of using a dictionary? because this way it is possible to express conditions"

	"There is no cascade execution. Only the matching case is executed"

	^ anArrayOfCases doCase: self
]

{ #category : #'*Seeker' }
BlockClosure >> whileFalseAlt: aBlock lvl: aNumber [

	1 to: aNumber do: [ :i | 
		self value ifTrue: [ ^ self ].
		aBlock value ].
	^ self whileFalseAlt: aBlock lvl: aNumber * 2
]

{ #category : #'*Seeker' }
BlockClosure >> whileTrueAlt: aBlock lvl: aNumber [

	1 to: aNumber do: [ :i | 
		self value ifFalse: [ ^ self ].
		aBlock value ].
	^ self whileTrueAlt: aBlock lvl: aNumber + 1
]
