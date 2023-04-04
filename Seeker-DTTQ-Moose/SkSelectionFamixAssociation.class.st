Class {
	#name : #SkSelectionFamixAssociation,
	#superclass : #SeekerSelectionFunction,
	#instVars : [
		'slotsOfInterest',
		'famixAssociationSlotsNames'
	],
	#category : #'Seeker-DTTQ-Moose-Functions-Selection'
}

{ #category : #accessing }
SkSelectionFamixAssociation >> collectFamixAssociationSlots [

	slotsOfInterest := OrderedCollection new.
	slotsOfInterest addAll:
		((FamixTAssociation users select: #isTrait) flatCollect: #slots).
	slotsOfInterest addAll: FamixTAssociation slots.
	slotsOfInterest := slotsOfInterest select: [ :s | s isKindOf: FMRelationSlot ].
	^slotsOfInterest
]

{ #category : #accessing }
SkSelectionFamixAssociation >> famixAssociationSlotsNames [

	^ self subclassResponsibility 
]

{ #category : #accessing }
SkSelectionFamixAssociation >> slotsOfInterest [

	^ slotsOfInterest ifNil: [ 
		  slotsOfInterest := self collectFamixAssociationSlots ]
]

{ #category : #evaluating }
SkSelectionFamixAssociation >> value: state [

	state isMessageSend 
		ifTrue: [
			|messageReceiverClass|
			messageReceiverClass := state messageReceiver class.
			^ (messageReceiverClass isMeta not and: [messageReceiverClass usesTrait: FamixTAssociation]) 
						and: [ self valueForStateAccessor: state ]].
		
	^ state node isVariable 
		and: [ self valueForStateAccess: state ]
]

{ #category : #evaluating }
SkSelectionFamixAssociation >> valueForReceiver: state [

	^ self famixAssociationSlotsNames includes: state messageReceiver
]

{ #category : #evaluating }
SkSelectionFamixAssociation >> valueForStateAccess: state [

	| rcvClass |
	rcvClass := state receiverClass.
	^ (rcvClass isMeta not and:[rcvClass usesTrait: FamixTAssociation]) 
		and: [ self famixAssociationSlotsNames includes: state node name ]
]

{ #category : #evaluating }
SkSelectionFamixAssociation >> valueForStateAccessor: state [

	state messageSelector = #value: ifTrue: [ 
		^ self valueForReceiver: state ].
	
	(#( 'cull:*' 'perform:*' ) anySatisfy: [ :matcher | matcher match: state messageSelector asString ]) 
				ifTrue: [ ^self famixAssociationSlotsNames includes: state messageArguments first ].	
	
	^(self famixAssociationSlotsNames includes: state messageSelector) 
		
]
