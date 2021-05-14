Extension { #name : #BlockClosureTest }

{ #category : #'*Seeker' }
BlockClosureTest >> testSwitchCase [

	| executedCorrectlyFlag aNumber result |
	executedCorrectlyFlag := false.

	"Test for value"
	[ 1 ] switchCase: { 
			(1 -> [ executedCorrectlyFlag := true ]).
			(2 -> [ nil ]).
			(#defaultCase -> [ nil ]) }.

	self assert: executedCorrectlyFlag.

	"Test for condition"
	executedCorrectlyFlag := false.
	aNumber := 5.
	result := [ true ] switchCase: { 
			          ([ aNumber > 0 ] -> [ #APositiveNumber ]).
			          ([ aNumber < 0 ] -> [ #ANegativeNumber ]).
			          ([ aNumber = 0 ] -> [ #Zero ]).
			          (#defaultCase -> #Impossible) }.
	self assert: result equals: #APositiveNumber.

	"Test for condition2"

	aNumber := 5.
	result := [ true ] switchCase: { 
			          (aNumber > 0 -> [ #APositiveNumber ]).
			          (aNumber < 0 -> [ #ANegativeNumber ]).
			          (aNumber = 0 -> [ #Zero ]).
			          (#defaultCase -> #Impossible) }.

	self assert: result equals: #APositiveNumber.

	"Test array Implementation (Should be in dedicated test class I think)"
	aNumber := -3.
	result := { 
		          (aNumber > 0 -> #APositiveNumber).
		          (aNumber < 0 -> #ANegativeNumber).
		          (aNumber = 0 -> #Zero).
		          (#defaultCase -> #Impossible) } doCase: true.

	self assert: result equals: #ANegativeNumber.

	"Test array Implementation (Should be in dedicated test class I think)"
	aNumber := 0.
	result := { 
		          (aNumber > 0 -> #APositiveNumber).
		          (aNumber < 0 -> #ANegativeNumber).
		          (#defaultCase -> #ExecutedDefault) } doCase: true.

	self assert: result equals: #ExecutedDefault
]
