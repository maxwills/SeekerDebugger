"
The IdentityEnforcer is used to define the implementation of the ""idenity recovery to maintain determinism on replay"" feature.
It is only used by the ObjectTracker, and it is part of the stepping pipeline.
"
Class {
	#name : #SkIdentityEnforcer,
	#superclass : #SkComponent,
	#instVars : [
		'objectsTracker',
		'currentState',
		'tracer'
	],
	#category : #'Seeker-Components'
}

{ #category : #initialization }
SkIdentityEnforcer >> bindComponents [

	tracer := componentsHolder tracer.
	currentState := componentsHolder currentState.
	objectsTracker := componentsHolder objectsTracker
]

{ #category : #accessing }
SkIdentityEnforcer >> doPostStepProcess [

	"Immediately after interpreting a bytecode, if it corresponds to an instantiation message primitive,
we check if we have the 'same' element from a previous replay. If so, we make the new object to have the old one.

(Side note, Instantiations are always local to the execution)
"

	| instancedObj previousIdentity |
	objectsTracker instantiationFlag ifFalse: [ ^ self ].

	instancedObj := currentState contextTop.
	instancedObj isReadOnlyObject ifTrue: [ ^ false ].
	previousIdentity := objectsTracker getObjectByOid:
		                    tracer bytecodeIndex.
	previousIdentity ifNotNil: [ "There are exceptional cases where objects oid differ by -1 (the previous identity is executedBytecode). Not sure yet why. The next if patches that."
		(previousIdentity class = instancedObj class and: [ 
			 previousIdentity canBecome ]) ifTrue: [ "previousIdentity copyFrom: instancedObj.
" 
			previousIdentity becomeForward: instancedObj copyHash: true "pointers to previousIdentity point now to instancedObj,  and instancedObj has previousIdentity identityHash" ] ]
]

{ #category : #accessing }
SkIdentityEnforcer >> enabled [

	^ SeekerConfig default identityEnforcingEnabled
]
