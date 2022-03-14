Extension { #name : #SpPresenter }

{ #category : #'*Seeker' }
SpPresenter >> findOwner: aPredicateBlock [

	"find the first owner in the owner chain that satisfies the predicate"

	"Inlcudes self"

	(aPredicateBlock cull: self) ifTrue: [ ^ self ].
	self owner ifNil: [ ^ nil ].
	^ self owner findOwner: aPredicateBlock
]
