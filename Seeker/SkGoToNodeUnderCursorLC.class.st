Class {
	#name : #SkGoToNodeUnderCursorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkGoToNodeUnderCursorLC >> description [
	^'Restarts the execution and replays it until the execution is at the node located under the cursor.'
]

{ #category : #executing }
SkGoToNodeUnderCursorLC >> executeCommand [

	self tracer perform timeTravelToSelectedNode
]

{ #category : #accessing }
SkGoToNodeUnderCursorLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkGoToNodeUnderCursorLC >> name [
	^'Go to node under cursor'
]
