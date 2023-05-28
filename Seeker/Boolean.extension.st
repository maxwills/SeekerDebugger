Extension { #name : #Boolean }

{ #category : #'*Seeker' }
Boolean >> forceTrueOrFalse [
"Used to ensure boolean values in AutoType expressions. This must be used if you use #ifTrue: and similar messages in a Autotype setter expression. 
"
	^ true == self
]
