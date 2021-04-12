Class {
	#name : #SeekerCommand,
	#superclass : #CmCommand,
	#category : #'Seeker-Commands'
}

{ #category : #initialization }
SeekerCommand class >> defaultIconName [
	^self subclassResponsibility 
]

{ #category : #initialization }
SeekerCommand class >> forSpecContext: anObject [
	self flag: 'Why is this class needed besides this helper?'.
	^ (self forSpecWithIconNamed: self defaultIconName)
		context: anObject;
		yourself
]

{ #category : #accessing }
SeekerCommand >> debuggerPresenter [
	^self context
]
