Class {
	#name : #SkRecursionsReturnValuesOfMethodUnderSelectionLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkRecursionsReturnValuesOfMethodUnderSelectionLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkRecursionsReturnValuesOfMethodUnderSelectionLC >> executeCommand [

	self seeker tracer find returnValuesOfSelection inspect
]

{ #category : #accessing }
SkRecursionsReturnValuesOfMethodUnderSelectionLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkRecursionsReturnValuesOfMethodUnderSelectionLC >> name [

	^'Recursions of Method Under Selection'
]
