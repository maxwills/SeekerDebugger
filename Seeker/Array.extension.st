Extension { #name : #Array }

{ #category : #'*Seeker' }
Array >> asSkXAnonymousType [
	AnonymousType newWith: self
]

{ #category : #'*Seeker' }
Array >> doCase: anExpression [

| exprValue defaultCaseBlock |
	exprValue := anExpression value.
	defaultCaseBlock := nil.
	self do: [ :each | 
		| key |
		key := each key value.
		key = exprValue ifTrue: [ ^ each value value ].
		key = #defaultCase ifTrue: [ defaultCaseBlock := each value ] ].
	defaultCaseBlock ifNotNil: [ ^ defaultCaseBlock value ].
	^ self error:
		  'doCase error. No matching case key or defaultCase found'
]
