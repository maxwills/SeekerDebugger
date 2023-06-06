Extension { #name : #ClassDescription }

{ #category : #'*Seeker' }
ClassDescription >> slotNamesIncludingSuperClasses [
	|mySlots|
	mySlots:= (self slots collect: [ :each | each name ]) asOrderedCollection.
	self = Object ifTrue: [ ^mySlots ].
	self = ProtoObject  ifTrue: [ ^mySlots ].
	mySlots addAll: superclass slotNamesIncludingSuperClasses.
	^mySlots 
]
