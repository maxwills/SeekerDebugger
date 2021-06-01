Class {
	#name : #SkAllInstanceCreationsLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsLC >> description [

		^ self commonDescriptionIntroString
	  ,
	  'for every <instance creation message send>. Every listed result corresponds to the moment before performing the object instantiation. (Sender''s point of view)'
]

{ #category : #executing }
SkAllInstanceCreationsLC >> executeCommand [

	self showResult:
		self tracer find allInstanceCreations asSeekerResultsCollection
			forInstancesCreation
]

{ #category : #accessing }
SkAllInstanceCreationsLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #smallNew
]

{ #category : #accessing }
SkAllInstanceCreationsLC >> name [

	^'All Instances Creation'
]
