Class {
	#name : #SkSelectionFamixReferenceNavigation,
	#superclass : #SkSelectionMessageSends,
	#category : #'Seeker-DTTQ-Moose-Functions'
}

{ #category : #accessing }
SkSelectionFamixReferenceNavigation >> famixReferenceSlotNames [
	^ #(#referencer #referredType #next #previous #source #target)
]

{ #category : #accessing }
SkSelectionFamixReferenceNavigation >> value: state [

	state isMessageSend ifTrue: [ ^ self valueForStateAccessor: state ].
	^ self valueForStateAccess: state
]

{ #category : #accessing }
SkSelectionFamixReferenceNavigation >> valueForStateAccess: state [

	| rcvClass |
	rcvClass := state receiverClass.

	^ rcvClass isMeta not and: [ 
		 " (rcvClass usesTrait: FamixTReference) and: [ "
			  state nodeIsVariable and: [ 
				  self famixReferenceSlotNames includes: state node name ] ] "]"
]

{ #category : #accessing }
SkSelectionFamixReferenceNavigation >> valueForStateAccessor: state [

	^ ((#( 'cull:*' 'perform:*' ) anySatisfy: [ :matcher | 
		    matcher match: state messageSelector asString]) and: [ 
		   self famixReferenceSlotNames includes:
			   state messageArguments first ]) or: [ 
		  (self famixReferenceSlotNames includes: state messageSelector) 
			  and: [ state messageReceiver class usesTrait: FamixTReference ] ]
]
