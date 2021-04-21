Class {
	#name : #SkNavigateHistoryBack,
	#superclass : #SeekerCommand,
	#category : #'Seeker-Commands'
}

{ #category : #default }
SkNavigateHistoryBack class >> defaultDescription [
	^'Navigate to the previous visited step'
]

{ #category : #initialization }
SkNavigateHistoryBack class >> defaultIconName [
	^#smallAdd 
]

{ #category : #default }
SkNavigateHistoryBack class >> defaultName [
	<seekerDebuggerCodeExtensionCommand: 50>
	^'Navigate to the previous step visited by the used'
]

{ #category : #executing }
SkNavigateHistoryBack >> execute [
	self seeker stepper navigateBack
]
