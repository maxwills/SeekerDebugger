Extension { #name : #Context }

{ #category : #'*Seeker' }
Context >> stepItToSendOrReturn [
	"Simulate the execution of bytecodes until either sending a message or 
	returning a value to the receiver (that is, until switching contexts)."

	| context |
	self flag: 'mwcode'.
	[ "self isDead or: [ self willSend or: [  self willReturn or: [ self willStore or: [self willCreateBlock ] ] ] ] " true]
		whileFalse: [
			context := self step.
			context == self ifFalse: [
				"Caused by mustBeBoolean handling"
				^context ]]
]
