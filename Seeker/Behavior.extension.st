Extension { #name : #Behavior }

{ #category : #'*Seeker' }
Behavior >> inheritsFromOrSameAs: aClass [

	^ SkObjectHelpers isClass: self class sameOrInheritsFrom: aClass
]
