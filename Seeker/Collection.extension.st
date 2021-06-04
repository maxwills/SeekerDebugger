Extension { #name : #Collection }

{ #category : #'*Seeker' }
Collection >> asScopedObjectDo: aBlock [

	self size = aBlock argumentCount ifFalse: [ 
		^ self error:
			  'The Collection size and the number of argument and  size must match' ].
	[ aBlock valueWithArguments: self ] ensure: [ 
		self do: [ :each | each finalize ].
		self finalize ]
]
