Class {
	#name : #SkNodeBeforeOrAfterCurrentLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkNodeBeforeOrAfterCurrentLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkNodeBeforeOrAfterCurrentLC >> executeCommand [

	| currentIndex selectedIndex |
	currentIndex := self tracer slowCurrentNode ordinalIndex.
	selectedIndex := self tracer selectedNode ordinalIndex.
	currentIndex > selectedIndex ifTrue: [ 
		^ self inform: '(selected < current)' ].
	currentIndex < selectedIndex ifTrue: [ 
		^ self inform: '(current < selected)' ].
	^ self inform: '(current = selected)'
]

{ #category : #accessing }
SkNodeBeforeOrAfterCurrentLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkNodeBeforeOrAfterCurrentLC >> name [

	^'Node Before or After'
]
