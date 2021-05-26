Extension { #name : #BlockClosure }

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
