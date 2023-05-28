Class {
	#name : #UTTQBugSeeker,
	#superclass : #UserTTQ,
	#category : #'Seeker-TimeTravelingQueries'
}

{ #category : #'as yet unclassified' }
UTTQBugSeeker class >> queryFastFrom: programStates buggyExpression: aBlockExp buggyExceptionPredicate: aBlock startingAtStep: aNumber collectingAs: aCollectAsBlock [

	| bs violationStatus |
	violationStatus := false.
	bs := [
	      | isIt |
	      isIt := false.
	      aBlockExp onErrorDo: [ :e |
		      Transcript
			      show: e asString;
			      cr.
		      isIt := aBlock value: e ].
	      isIt ].
	^ (self queryFrom: programStates)
		  select: [ :state |
			  | currentStatus |
			  state bytecodeIndex >= aNumber and: [
				  currentStatus := bs value.
				  currentStatus = violationStatus
					  ifFalse: [
						  violationStatus := currentStatus.
						  true ]
					  ifTrue: [ false ] ] ]
		  collectAs: [ :state :res |
			  aCollectAsBlock value: state value: res.
			  res
				  violationStatus: violationStatus ]
]

{ #category : #'as yet unclassified' }
UTTQBugSeeker class >> queryFrom: programStates buggyExpression: aBlockExp buggyExceptionPredicate: aBlock startingAtStep: aNumber collectingAs: aCollectAsBlock [

	| bs isGoodStatus |
	isGoodStatus := true.
	bs := BugSeeker new: (SeekerDebugger headlessDebugBlock: aBlockExp).
	bs exceptionPredicate: aBlock.
	^ (self queryFrom: programStates)
		  select: [ :state |
			  | currentStatus |
			  state bytecodeIndex >= aNumber and: [
				  currentStatus := bs execute.
				  currentStatus = isGoodStatus
					  ifFalse: [
						  isGoodStatus := currentStatus.
						  true ]
					  ifTrue: [ false ] ] ]
		  collectAs: [ :state :res |
			  aCollectAsBlock value: state value: res.
			  res
				  isGood: isGoodStatus;
				  code: state node parent sourceCode;
				  node: state node ]
]

{ #category : #'as yet unclassified' }
UTTQBugSeeker >> ttqTitle [

	^ 'Seeks bugs. To be used only by scripting'
]
