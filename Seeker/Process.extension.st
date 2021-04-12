Extension { #name : #Process }

{ #category : #'*Seeker' }
Process >> stepItToSendOrReturn [
self flag:'mwcode'.
	^Processor activeProcess
		evaluate: [suspendedContext := suspendedContext stepItToSendOrReturn]
		onBehalfOf: self
]
