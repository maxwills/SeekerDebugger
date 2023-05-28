Class {
	#name : #SkSelectionMicElementInstanceCreation,
	#superclass : #SkSelectionInstanceCreations,
	#category : #'Seeker-DTTQ-Microdown-Functions'
}

{ #category : #accessing }
SkSelectionMicElementInstanceCreation >> value: programState [

	^ (super value: programState) and: [
		  (MicAbstractBlock allSubclasses collect: #name) includes:
			  programState classNameOfObjectAboutToBeInstantiated ]
]
