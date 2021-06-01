Class {
	#name : #SkAllInstanceCreationsOfClassLC,
	#superclass : #SeekerLiteCommand,
	#category : #'Seeker-Commands'
}

{ #category : #accessing }
SkAllInstanceCreationsOfClassLC >> description [

	^ self commonDescriptionIntroString
	  ,
	  'for every <instance creation message send> that will instantiate an object of the class whose name matches the <selected text>. Every listed result corresponds to the moment before performing the object instantiation. (Sender''s point of view)'
]

{ #category : #executing }
SkAllInstanceCreationsOfClassLC >> executeCommand [

	self showResult:
		self tracer find allInstanceCreationsOfClassNamedAsSelectedCode
			asSeekerResultsCollection forInstancesCreation
]

{ #category : #accessing }
SkAllInstanceCreationsOfClassLC >> icon [

"Inspect the following line and choose an icon for the command

(Smalltalk ui icons)

"

	^ #smallNew
]

{ #category : #accessing }
SkAllInstanceCreationsOfClassLC >> name [

	^'All Instances Creation of class named as selection'
]

{ #category : #'as yet unclassified' }
SkAllInstanceCreationsOfClassLC >> selectionTitleString [

	^ ' : (' , self codeSelectedText , ')'
]
