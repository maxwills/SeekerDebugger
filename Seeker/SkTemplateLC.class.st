Class {
	#name : #SkTemplateLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkTemplateLC >> description [

	^'MyCommand description'
]

{ #category : #executing }
SkTemplateLC >> executeCommand [

	 self inform: 'command working'
]

{ #category : #accessing }
SkTemplateLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #add
]

{ #category : #accessing }
SkTemplateLC >> name [

	^'MyCommand name'
]
