Extension { #name : #Number }

{ #category : #'*Seeker' }
Number >> += aNumber [

	"equivalent to x := x + aNumber"

	| senderContext msgNode variable |
	senderContext := thisContext sender.
	"The node should be a message send. The receiver should be a variable
Therefore, what needs to happen is that the value stored by that variable is 
inscreased by aNumber. There are several ways to achieve that.
"
	msgNode := senderContext method sourceNodeForPC:
		           senderContext executedPC.
	variable := msgNode receiver variable.
	^ variable write: self + aNumber inContext: senderContext
]
