Class {
	#name : #SkReturnValuesOfMethodWithSelectedSelectorLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkReturnValuesOfMethodWithSelectedSelectorLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkReturnValuesOfMethodWithSelectedSelectorLC >> executeCommand [

	(self seeker tracer find returnValuesOfAnyMessageSendWithSelector:
		 self seeker tracer selectedSelector) inspect
]

{ #category : #accessing }
SkReturnValuesOfMethodWithSelectedSelectorLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkReturnValuesOfMethodWithSelectedSelectorLC >> name [

	^'Recursions of any method with selected selector '
]
