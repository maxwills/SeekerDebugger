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

{ #category : #'*Seeker' }
Array >> newWith: aBlock [

	"Instantiates the anonymousType class (if it doesn't exists) and then executes the block"

	| cls |
	cls := self at: 1.
	cls = AnonymousType ifTrue: [ 
		| builder |
		builder := MyDynamicTypeBuilder new.
		aBlock value: builder.
		cls := builder endNewType.
		self at: 1 put: cls ].
	^ aBlock value: cls new
]
