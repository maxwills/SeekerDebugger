Extension { #name : #Object }

{ #category : #'*Seeker' }
Object class >> atSeekerAuxStorage1 [

	^ SeekerGlobals instance auxiliaryTempStorage1
]

{ #category : #'*Seeker' }
Object class >> atSeekerAuxStorage2 [

	^ SeekerGlobals instance auxiliaryTempStorage2
]

{ #category : #'*Seeker' }
Object >> defaultSeekerCacheObjectClass [

	^ SeekerCacheObject
]

{ #category : #'*Seeker' }
Object >> putInSeekerAuxStorage1 [
	SeekerGlobals instance auxiliaryTempStorage1: self
]

{ #category : #'*Seeker' }
Object >> putInSeekerAuxStorage2 [
	SeekerGlobals instance auxiliaryTempStorage2: self
]

{ #category : #'*Seeker' }
Object >> seekAllChangesOnSelf [
	

]

{ #category : #'*Seeker' }
Object >> seekerCache [

	^ SeekerCache seekerCacheObjectOf: self
]
