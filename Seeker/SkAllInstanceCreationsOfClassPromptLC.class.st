Class {
	#name : #SkAllInstanceCreationsOfClassPromptLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsOfClassPromptLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <instance creation message send> that will instantiate an object of the class whose name matches the <selected text>.'
]

{ #category : #executing }
SkAllInstanceCreationsOfClassPromptLC >> executeCommand [

	| className |
	className := SkInteractivelyQueryFromHelper requestClassName.
	self showResultFor: (TTQAllInstanceCreationsOfClassWithName
			 queryFrom: self tracer newProgramStates
			 withClassName: className)
]

{ #category : #accessing }
SkAllInstanceCreationsOfClassPromptLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #smallNew
]

{ #category : #accessing }
SkAllInstanceCreationsOfClassPromptLC >> name [

	^'All Instances Creation of class named...'
]

{ #category : #'as yet unclassified' }
SkAllInstanceCreationsOfClassPromptLC >> selectionTitleString [

	^ ' : (user input)'
]
