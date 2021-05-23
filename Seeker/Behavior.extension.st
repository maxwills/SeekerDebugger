Extension { #name : #Behavior }

{ #category : #'*Seeker' }
Behavior >> inheritsFromOrSameAs: aClass [

	^ SkObjectHelpers isClass: self sameOrInheritsFrom: aClass
]
